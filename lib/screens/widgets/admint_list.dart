import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/action_store.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:diplome_aisha/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AdminList extends StatefulWidget {

  AdminList({super.key,  });

  @override
  State<AdminList> createState() => _AdminListState();
}

class _AdminListState extends State<AdminList> {
  final _firestore = FirebaseFirestore.instance;
  final localStore = serviceLocator<LocalStore>();

  @override
  Widget build(BuildContext context) {
    if (localStore.documents.isNotEmpty) {
      return Observer(
        builder: (context) {
          return ListView.builder(
                itemCount: localStore.documents.length,
                itemBuilder: (context, index) {
                  Document doc = localStore.documents[index];
                  return Column(
                    children: [
                      Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              // An action can be bigger than the others.
                              flex: 2,
                              onPressed: (context) {
                                _firestore.collection("/documents").doc(doc.id).delete();
                                localStore.fetchDocuments();
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Удалить',
                            ),

                          ],
                        ),
                        child: ListTile(
                            title: Text(doc.name!),
                            onTap: () async {
                              String? downloadUrl =
                                  doc.downloadUrl; // URL-адрес файла
                              context.push("/pdf", extra: {"pdfUrl": downloadUrl});
                            }),
                      ),
                      const Divider()
                    ],
                  );
                });
        }
      );
    } else {
      return const Center(
            child: Text("Добавьте файл"),
          );
    }
  }
}
