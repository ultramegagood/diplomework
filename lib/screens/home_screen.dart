import 'package:diplome_aisha/action_store.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:diplome_aisha/models/models.dart' as models;
import 'package:diplome_aisha/screens/widgets/admint_list.dart';
import 'package:diplome_aisha/screens/widgets/teacher_list.dart';
import 'package:diplome_aisha/service_locator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  }

  bool loading = false;

  @override
  void didUpdateWidget(covariant UploadDocumentScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  showSort() async {
    List<String> selectedIds = [];
    List<String> selectedYears = [];

    await showModalBottomSheet(
        context: context,
        builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Сортировка:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ExpandablePanel(
                      theme: const ExpandableThemeData(
                        tapHeaderToExpand: true,
                        tapBodyToCollapse: true,
                        hasIcon: true,
                      ),
                      header: Text(
                        "По пользователям",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      expanded: WrapUsers(
                        onSelected: (v) {
                          selectedIds = v;
                        },
                      ),
                      collapsed: const SizedBox()),
                  ExpandablePanel(
                      theme: const ExpandableThemeData(
                        tapHeaderToExpand: true,
                        tapBodyToCollapse: true,
                        hasIcon: true,
                      ),
                      header: Text(
                        "По годам",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      expanded: WrapYear(
                        onSelected: (v) {
                          selectedYears = v;
                        },
                      ),
                      collapsed: const SizedBox()),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          localStore.setSelectedUserIds([...selectedIds]);
                          localStore.setSelectedYears([...selectedYears]);
                        },
                        child: const Text("Сохранить")),
                  )
                ],
              ),
            )).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localStore.user?.fullname ?? ""),
        leading:loading?null: IconButton(
          onPressed: () {
            context.push("/profile");
          },
          icon: const Icon(Icons.account_circle),
        ),
        actions:loading?[]: [
          if (localStore.user?.role != "teacher")
            IconButton(
                onPressed: () {
                  exportToExcel([localStore.user!], localStore.documents);
                },
                icon: const Icon(Icons.ios_share)),
          if (localStore.user?.role != "teacher")
            IconButton(
                onPressed: () {
                  context.push("/users");
                },
                icon: const Icon(Icons.supervisor_account_rounded)),
          if (localStore.user?.role != "teacher")
            IconButton(
                onPressed: showSort, icon: const Icon(Icons.import_export))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push("/document"),
        child: const Icon(Icons.add),
      ),
      body: Observer(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                        child: localStore.user?.role == "teacher"
                            ? const TeacherList()
                            : const AdminList()),
                  ],
                ),
        );
      }),
    );
  }
}

class WrapUsers extends StatefulWidget {
  final Function(List<String> ids) onSelected;

  const WrapUsers({super.key, required this.onSelected});

  @override
  State<WrapUsers> createState() => _WrapUsersState();
}

class _WrapUsersState extends State<WrapUsers> {
  final localStore = serviceLocator<LocalStore>();
  List<String> selectedIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIds = localStore.selectedUserIds;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          runAlignment: WrapAlignment.start,
          spacing: 4,
          runSpacing: 4,
          children: [
            ...localStore.users.map((e) => GestureDetector(
                  onTap: () async {
                    setState(() {
                      if (!selectedIds.contains(e.id)) {
                        selectedIds.add(e.id!);
                      } else {
                        selectedIds.remove(e.id!);
                      }
                      widget.onSelected(selectedIds);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedIds.contains(e.id)
                            ? Colors.greenAccent
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(e.fullname.toString()),
                  ),
                ))
          ],
        ),
      ],
    );
  }
}

class WrapYear extends StatefulWidget {
  final Function(List<String> dates) onSelected;

  const WrapYear({super.key, required this.onSelected});

  @override
  State<WrapYear> createState() => _WrapYearState();
}

class _WrapYearState extends State<WrapYear> {
  final localStore = serviceLocator<LocalStore>();
  List<String> selectedIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIds = localStore.selectedYears;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          runAlignment: WrapAlignment.start,
          spacing: 4,
          runSpacing: 4,
          children: [
            ...localStore.documents
                .map((e) => e.date)
                .toSet()
                .map((e) => GestureDetector(
                      onTap: () async {
                        setState(() {
                          if (!selectedIds.contains(e)) {
                            selectedIds.add(e!);
                          } else {
                            selectedIds.remove(e);
                          }
                          widget.onSelected(selectedIds);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: selectedIds.contains(e)
                                ? Colors.greenAccent
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(e.toString()),
                      ),
                    ))
          ],
        ),
      ],
    );
  }
}
