import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? _dateYear;
  String? _filePath;
  String? _userId;
  Uint8List? fileBytes;
  final _formKey = GlobalKey<FormState>();
  final _controllerName = TextEditingController();
  final _controllerDate = TextEditingController();
  final _controllerPerechen = TextEditingController();
  final _controllerInterWorks = TextEditingController();
  final _controllerInterConfWorks = TextEditingController();
  final _controllerNameBook = TextEditingController();
  String? docId;

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

  late Document doc;

  Future<void> _uploadDocument() async {
    _userId = FirebaseAuth.instance.currentUser?.uid;
    try {
      String fileName = '$_documentName';
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

      await _firestore.collection('documents').add({
        'name': _controllerName.text,
        'userId': _userId,
        'downloadUrl': downloadUrl,
        'date': _dateYear,
        'perechen': _controllerPerechen.text,
        'interWorks': _controllerInterWorks.text,
        'interConfWorks': _controllerInterConfWorks.text,
        'nameBook': _controllerNameBook.text,
      }).then((value) {
        docId = value.id;
      });
      await _firestore.collection('documents').doc(docId).update({
        "id": docId,
        'name': _controllerName.text,
        'userId': _userId,
        'downloadUrl': downloadUrl,
        'date': _dateYear,
        'perechen': _controllerPerechen.text,
        'interWorks': _controllerInterWorks.text,
        'interConfWorks': _controllerInterConfWorks.text,
        'nameBook': _controllerNameBook.text,
      });

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
          content: SizedBox(
            // Устанавливаем высоту контейнера, чтобы ограничить количество показываемых лет
            height: 300,
            width: 100,
            child: YearPicker(
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              selectedDate: initialDate,
              onChanged: (DateTime dateTime) {
                _dateYear = dateTime.year.toString();
                _controllerDate.text = dateTime.year.toString();

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
      appBar: AppBar(

        title: const Text('Загрузить документ'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _filePath != null
            ? Form(
                key: _formKey,
                child:      ListView(     keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag ,

                  children: [
                    TextFormField(
                      controller: _controllerName,
                      decoration: const InputDecoration(labelText: 'Название'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter document name' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      onTap: () => _selectYear(context),
                      controller: _controllerDate,
                      decoration:
                          const InputDecoration(labelText: 'Дата (год)'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllerPerechen,
                      decoration: const InputDecoration(labelText: 'Перечень'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllerInterWorks,
                      decoration: const InputDecoration(
                          labelText: 'Меж. народные работы'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllerInterConfWorks,
                      decoration: const InputDecoration(
                          labelText: 'Меж. народные конференций'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllerNameBook,
                      decoration:
                          const InputDecoration(labelText: 'Названия учебника'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                         await _uploadDocument();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              )
            : Center(
                child: ElevatedButton(
                  onPressed: _pickDocument,
                  child: const Text("Загрузить Документ"),
                ),
              ),
      ),
    );
  }
}
