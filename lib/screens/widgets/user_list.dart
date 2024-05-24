import 'package:diplome_aisha/action_store.dart';
import 'package:diplome_aisha/models/models.dart';
import 'package:diplome_aisha/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final localStore = serviceLocator<LocalStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Пользователи"),
      ),
      body: Observer(
        builder: (context) {
          return ListView.builder(
              itemCount: localStore.users.length,
              itemBuilder: (context, index) {
                User doc = localStore.users[index];
                return ListTile(
                    title: Text(doc.fullname!),
                    onTap: () async {
                      context.push("/user-profile",extra: {
                        "uid":doc.id
                      });
                    });
              });
        }
      ),
    );
  }
}
