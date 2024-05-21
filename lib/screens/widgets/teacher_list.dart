import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class TeacherList extends StatefulWidget {
  List<Document> documents;
  TeacherList({super.key, required this.documents});

  @override
  State<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends State<TeacherList> {
  final _firestore = FirebaseFirestore.instance;
  String? _username;
  User? _user;
  String? _userId;
  String? _userRole;
  Uint8List? fileBytes;
  List<Document> _documents = [];
  List<Document> _documentsAdmin = [];

  bool loading = false;

  void _fetchDocuments() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await _firestore
        .collection('documents')
        .where('userId', isEqualTo: _userId)
        .get();
    QuerySnapshot querySnapshotAdmin =
    await _firestore.collection('documents').get();
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: _userId)
        .get();

    setState(() {
      _documents = querySnapshot.docs
          .map((doc) => Document.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      _documentsAdmin = querySnapshotAdmin.docs
          .map((doc) => Document.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      _username = snapshot.docs
          .map(
              (doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .first
          .fullname;
      _userRole = snapshot.docs
          .map(
              (doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .first
          .role;
      _user=  snapshot.docs
          .map(
              (doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .first;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return   widget.documents.isNotEmpty
        ? ListView.builder(
        itemCount: widget.documents.length,
        itemBuilder: (context, index) {
          Document doc = widget.documents[index];
          return ListTile(
              title: Text(doc.name!),
              onTap: () async {
                String? downloadUrl =
                    doc.downloadUrl; // URL-адрес файла
                context
                    .push("/pdf", extra: {"pdfUrl": downloadUrl}).then((value) => _fetchDocuments());
              });
        })
        : const Center(
      child: Text("Добавьте файл"),
    );
  }
}
