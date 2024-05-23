// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocalStore on _LocalStore, Store {
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

  @override
  String toString() {
    return '''
user: ${user},
documents: ${documents},
users: ${users}
    ''';
  }
}
