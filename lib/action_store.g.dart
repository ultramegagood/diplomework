// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocalStore on _LocalStore, Store {
  Computed<List<model.Document>?>? _$adminDocsComputed;

  @override
  List<model.Document>? get adminDocs => (_$adminDocsComputed ??=
          Computed<List<model.Document>?>(() => super.adminDocs,
              name: '_LocalStore.adminDocs'))
      .value;

  late final _$userAtom = Atom(name: '_LocalStore.user', context: context);

  @override
  model.User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(model.User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$documentsAtom =
      Atom(name: '_LocalStore.documents', context: context);

  @override
  List<model.Document> get documents {
    _$documentsAtom.reportRead();
    return super.documents;
  }

  @override
  set documents(List<model.Document> value) {
    _$documentsAtom.reportWrite(value, super.documents, () {
      super.documents = value;
    });
  }

  late final _$selectedUserIdsAtom =
      Atom(name: '_LocalStore.selectedUserIds', context: context);

  @override
  List<String> get selectedUserIds {
    _$selectedUserIdsAtom.reportRead();
    return super.selectedUserIds;
  }

  @override
  set selectedUserIds(List<String> value) {
    _$selectedUserIdsAtom.reportWrite(value, super.selectedUserIds, () {
      super.selectedUserIds = value;
    });
  }

  late final _$selectedYearsAtom =
      Atom(name: '_LocalStore.selectedYears', context: context);

  @override
  List<String> get selectedYears {
    _$selectedYearsAtom.reportRead();
    return super.selectedYears;
  }

  @override
  set selectedYears(List<String> value) {
    _$selectedYearsAtom.reportWrite(value, super.selectedYears, () {
      super.selectedYears = value;
    });
  }

  late final _$usersAtom = Atom(name: '_LocalStore.users', context: context);

  @override
  List<model.User> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<model.User> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$sortedUserAtom =
      Atom(name: '_LocalStore.sortedUser', context: context);

  @override
  List<model.User> get sortedUser {
    _$sortedUserAtom.reportRead();
    return super.sortedUser;
  }

  @override
  set sortedUser(List<model.User> value) {
    _$sortedUserAtom.reportWrite(value, super.sortedUser, () {
      super.sortedUser = value;
    });
  }

  late final _$fetchUserAsyncAction =
      AsyncAction('_LocalStore.fetchUser', context: context);

  @override
  Future<void> fetchUser() {
    return _$fetchUserAsyncAction.run(() => super.fetchUser());
  }

  late final _$fetchDocumentsAsyncAction =
      AsyncAction('_LocalStore.fetchDocuments', context: context);

  @override
  Future<void> fetchDocuments() {
    return _$fetchDocumentsAsyncAction.run(() => super.fetchDocuments());
  }

  late final _$_LocalStoreActionController =
      ActionController(name: '_LocalStore', context: context);

  @override
  void sortUsersById() {
    final _$actionInfo = _$_LocalStoreActionController.startAction(
        name: '_LocalStore.sortUsersById');
    try {
      return super.sortUsersById();
    } finally {
      _$_LocalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedUserIds(List<String> userIds) {
    final _$actionInfo = _$_LocalStoreActionController.startAction(
        name: '_LocalStore.setSelectedUserIds');
    try {
      return super.setSelectedUserIds(userIds);
    } finally {
      _$_LocalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedYears(List<String> years) {
    final _$actionInfo = _$_LocalStoreActionController.startAction(
        name: '_LocalStore.setSelectedYears');
    try {
      return super.setSelectedYears(years);
    } finally {
      _$_LocalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
documents: ${documents},
selectedUserIds: ${selectedUserIds},
selectedYears: ${selectedYears},
users: ${users},
sortedUser: ${sortedUser},
adminDocs: ${adminDocs}
    ''';
  }
}
