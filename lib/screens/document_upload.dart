import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({super.key});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  late Document document;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  bool loading = false;

  File? _document;
  String? _documentName;
  String? _username;
  String? _filePath;
  String? _userId;
  String? _userRole;
  Uint8List? fileBytes;

  Future _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.any, allowMultiple: false);

    if (result != null) {
      setState(() {
        fileBytes = result.files.first.bytes;
        _filePath = result.files.single.path;
        _document = File(_filePath!);
        _documentName = result.files.single.name;
      });
    }
  }

  void _uploadDocument() async {
    try {
      await _pickDocument();
      String fileName = '${_documentName}';
      setState(() {
        loading = true;
      });

      TaskSnapshot? snapshot;
      if (Platform.isAndroid || Platform.isIOS) {
        snapshot = await _storage
            .ref()
            .child('documents/$fileName')
            .putFile(_document!);
      } else {
        snapshot = await _storage
            .ref()
            .child('documents/$fileName')
            .putData(fileBytes!);
      }
      String downloadUrl = await snapshot.ref.getDownloadURL();

      DocumentReference docRef = await _firestore.collection('documents').add({
        'name': document.name,
        'userId': _userId,
        'downloadUrl': downloadUrl,
      });
      String docId = docRef.id;

      Document doc = Document(
        name: _documentName!,
        userId: _userId!,
        downloadUrl: downloadUrl,
        date: '',
        perechen: '',
        interWorks: '',
        interConfWorks: '',
        authors: [],
        id: docId,
        nameBook: '',
      );

      await _firestore.collection("documents").doc(doc.id).set(doc.toJson());

      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  int? selectedYear;

  Future<void> _selectYear(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year);
    final picked = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите год'),
          content: Container(
            // Устанавливаем высоту контейнера, чтобы ограничить количество показываемых лет
            height: 300,
            width: 100,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              selectedDate: initialDate,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );
    if (picked != null && picked != selectedYear) {
      setState(() {
        selectedYear = picked;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Загрузка документа:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Название'),
                  onChanged: (v) {
                    document.name = v;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: ()=>_selectYear(context),
                  child: TextField(
                    readOnly: true,
                    enabled: false,

                    decoration: const InputDecoration(labelText: 'Дата'),
                    onChanged: (v) {
                      document.date = v;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Перечень'),
                  onChanged: (v) {
                    document.perechen = v;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: 'Меж. народные работы'),
                  onChanged: (v) {
                    document.interWorks = v;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: const InputDecoration(
                      labelText: 'Меж. народные конфересий '),
                  onChanged: (v) {
                    document.interConfWorks = v;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: 'Названия учебника'),
                  onChanged: (v) {
                    document.nameBook = v;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    document;
                  },
                  child: const Text("Загрузить"))
            ],
          ),
        ),
      ),
    );
  }
}
