import 'package:diplome_aisha/action_store.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:diplome_aisha/models/models.dart' as models;
import 'package:diplome_aisha/screens/widgets/admint_list.dart';
import 'package:diplome_aisha/screens/widgets/teacher_list.dart';
import 'package:diplome_aisha/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

// Функция для экспорта данных в Excel
Future<void> exportToExcel(
    List<models.User> users, List<Document> documents) async {
  var excel = Excel.createExcel();

  // Создание листа для пользователей и документов
  Sheet combinedSheet = excel['Users and Documents'];
  combinedSheet.appendRow(const [
    TextCellValue("User ID"),
    TextCellValue('Full Name'),
    TextCellValue('Email'),
    TextCellValue('Password'),
    TextCellValue('Work Experience'),
    TextCellValue('Degree'),
    TextCellValue('Role'),
    TextCellValue('Diplome'),
    TextCellValue('Document ID'),
    TextCellValue('Document Name'),
    TextCellValue('Download URL'),
    TextCellValue('Document Date'),
    TextCellValue('Perechen'),
    TextCellValue('Inter Works'),
    TextCellValue('Inter Conf Works'),
    TextCellValue('Name Book'),
    TextCellValue('Authors')
  ]);

  for (var user in users) {
    var userDocuments =
        documents.where((doc) => doc.userId == user.id).toList();
    if (userDocuments.isNotEmpty) {
      for (var document in userDocuments) {
        combinedSheet.appendRow([
          TextCellValue(user.id!),
          TextCellValue(user.fullname!),
          TextCellValue(user.email!),
          TextCellValue(user.password!),
          TextCellValue(user.workExperience!),
          TextCellValue(user.degree!),
          TextCellValue(user.role!),
          TextCellValue(user.diplome!),
          TextCellValue(document.id!),
          TextCellValue(document.name!),
          TextCellValue(document.downloadUrl!),
          TextCellValue(document.date!),
          TextCellValue(document.perechen!),
          TextCellValue(document.interWorks!),
          TextCellValue(document.interConfWorks!),
          TextCellValue(document.nameBook!),
          TextCellValue(document.authors.toString())
        ]);
      }
    } else {
      combinedSheet.appendRow([
        TextCellValue(user.id!),
        TextCellValue(user.fullname!),
        TextCellValue(user.email!),
        TextCellValue(user.password!),
        TextCellValue(user.workExperience!),
        TextCellValue(user.degree!),
        TextCellValue(user.role!),
        TextCellValue(user.diplome!),
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null
      ]);
    }
  }

  // Сохранение файла
  Directory directory = await getApplicationDocumentsDirectory();
  String path = '${directory.path}/users_and_documents.xlsx';
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.save()!);

  print('Excel file saved at $path');

  // Предложить поделиться файлом
  Share.shareFiles([path], text: 'Поделиться');
}

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final localStore = serviceLocator<LocalStore>();

  @override
  void initState() {
    fetchData();
  }

  fetchData() async {
    setState(() {
      loading = true;
    });
    await localStore.fetchUser();
    await localStore.fetchDocuments();
    setState(() {
      loading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    localStore.fetchDocuments();
  }

  bool loading = false;

  @override
  void didUpdateWidget(covariant UploadDocumentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localStore.user?.fullname ?? ""),
        leading: IconButton(
          onPressed: () {
            context.push("/profile");
          },
          icon: const Icon(Icons.account_circle),
        ),
        actions: [
          if (localStore.user?.role != "teacher")
            IconButton(
                onPressed: () {
                  exportToExcel([localStore.user!], localStore.documents);
                },
                icon: const Icon(Icons.import_export)),
          if (localStore.user?.role != "teacher")
            IconButton(
                onPressed: () {
                  context.push("/users");
                },
                icon: const Icon(Icons.supervisor_account_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/document"),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                      child: localStore.user?.role == "teacher"
                          ? TeacherList()
                          : AdminList()),
                ],
              ),
      ),
    );
  }
}
