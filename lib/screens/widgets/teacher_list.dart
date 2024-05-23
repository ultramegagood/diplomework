import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/action_store.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml.dart';
import 'package:xml/xml.dart';

import '../../service_locator.dart';

class TeacherList extends StatefulWidget {
  TeacherList({
    super.key,
  });

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  final localStore = serviceLocator<LocalStore>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return localStore.documents.isNotEmpty
        ? Observer(
          builder: (context) {
            return ListView.builder(
                itemCount: localStore.documents.length,
                itemBuilder: (context, index) {
                  Document doc = localStore.documents[index];
                  return ListTile(
                      title: Text(doc.name!),
                      onTap: () async {
                        String? downloadUrl = doc.downloadUrl; // URL-адрес файла
                        context.push("/pdf", extra: {"pdfUrl": downloadUrl}).then(
                            (value) => localStore.fetchDocuments());
                      });
                });
          }
        )
        : const Center(
            child: Text("Добавьте файл"),
          );
  }
}
