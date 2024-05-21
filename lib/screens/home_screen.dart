import 'dart:developer';
import 'package:diplome_aisha/models/models.dart';
import 'package:diplome_aisha/models/models.dart' as models;
import 'package:diplome_aisha/screens/widgets/admint_list.dart';
import 'package:diplome_aisha/screens/widgets/teacher_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class UploadDocumentScreen extends StatefulWidget {
  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  File? _document;
  String? _documentName;
  String? _username;
  String? _filePath;
  String? _userId;
  String? _userRole;
  Uint8List? fileBytes;

  List<Document> _documents = [];
  List<Document> _documentsAdmin = [];

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
    _fetchDocuments();
  }

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
              (doc) => models.User.fromJson(doc.data() as Map<String, dynamic>))
          .first
          .fullname;
      _userRole = snapshot.docs
          .map(
              (doc) => models.User.fromJson(doc.data() as Map<String, dynamic>))
          .first
          .role;
      loading = false;
    });
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchDocuments();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_username ?? ""),
        leading: IconButton(onPressed: () {
          context.push("/profile");
        }, icon: const Icon(Icons.account_circle),),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                context.replace("/auth");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>context.push("/document"),
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
                      child: _userRole == "teacher"
                          ? TeacherList(
                              documents: _documents,
                            )
                          : AdminList(
                              documents: _documentsAdmin,
                            )),
                ],
              ),
      ),
    );
  }
}
