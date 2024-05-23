import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplome_aisha/models/models.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'action_store.g.dart';

// This is the class used by rest of your codebase
class LocalStore = _LocalStore with _$LocalStore;

// The store-class
abstract class _LocalStore with Store {
  final _firestore = FirebaseFirestore.instance;
  @observable
  model.User? user;
  @observable
  List<model.Document> documents = [];

  @observable
  List<model.User> users = [];
  @observable
  List<model.Document> documentsAdmin = [];

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
        .map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>)).toList();
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

    documents = querySnapshot.docs
        .map((doc) =>
            model.Document.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    documentsAdmin = querySnapshotAdmin.docs
        .map((doc) =>
            model.Document.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    user = snapshot.docs
        .map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>))
        .firstOrNull;
  }

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
