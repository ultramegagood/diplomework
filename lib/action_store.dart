import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/models/models.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'action_store.g.dart';

class LocalStore = _LocalStore with _$LocalStore;

abstract class _LocalStore with Store {
  @observable
  model.User? user;
  @observable
  List<model.Document> documents = [];

  @computed
  List<model.Document>? get adminDocs => _computeAdminDic();
  final _firestore = FirebaseFirestore.instance;
  @observable
  List<String> selectedUserIds = [];

  @observable
  List<String> selectedYears = [];

  @observable
  List<model.User> users = [];

  @observable
  List<model.User> sortedUser = [];

  List<model.Document> _computeAdminDic() {
    List<model.Document> doc = [];

    // Фильтруем документы по выбранным пользователям, если они выбраны
    if (selectedUserIds.isNotEmpty && !selectedYears.isNotEmpty) {
      doc.addAll(documents
          .where((document) => selectedUserIds.contains(document.userId))
          .toList());
    }

    // Фильтруем документы по выбранным годам, если они выбраны
    if (selectedYears.isNotEmpty && !selectedUserIds.isNotEmpty) {
      doc.addAll(documents
          .where((document) => selectedYears.contains(document.date))
          .toList());
    }
    if (selectedYears.isNotEmpty && selectedUserIds.isNotEmpty) {
      doc.addAll(documents
          .where((document) =>
              selectedYears.contains(document.date) &&
              selectedUserIds.contains(document.userId))
          .toList());
    }
    log("$selectedYears $selectedUserIds");
    if (selectedYears.isEmpty && selectedUserIds.isEmpty) {
      doc = documents;
    }
    return doc;
  }

  @action
  void sortUsersById() {
    sortedUser = List.from(users);
    sortedUser.sort((a, b) => a.id!.compareTo(b.id!));
  }

  @action
  void setSelectedUserIds(List<String> userIds) {
    selectedUserIds = userIds;
  }

  @action
  void setSelectedYears(List<String> years) {
    selectedYears = years;
  }

  @action
  Future<void> fetchUser() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    QuerySnapshot usersSnapshot = await _firestore.collection('users').get();

    user = querySnapshot.docs
        .map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>))
        .firstOrNull;
    users = usersSnapshot.docs
        .map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @action
  Future<void> fetchDocuments() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('documents')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    QuerySnapshot querySnapshotAdmin =
        await _firestore.collection('documents').get();
    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (user?.role == "teacher") {
      documents = querySnapshot.docs
          .map((doc) =>
              model.Document.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } else {
      documents = querySnapshotAdmin.docs
          .map((doc) =>
              model.Document.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    }

    user = snapshot.docs
        .map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>))
        .firstOrNull;
  }
}
