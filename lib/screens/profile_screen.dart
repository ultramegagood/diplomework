import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart' as model;

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllerFullName = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerWorkExperience = TextEditingController();
  final _controllerDegree = TextEditingController();
  final _controllerDiplome = TextEditingController();

  bool loading = false;
  model.User? user;

  fetchData() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    user = snapshot.docs
        .map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>))
        .first;

    _controllerFullName.text = user!.fullname!;
    _controllerEmail.text = user!.email!;
    _controllerWorkExperience.text = user!.workExperience!;
    _controllerDegree.text = user!.degree!;
    _controllerDiplome.text = user!.diplome!;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  showDegrees() {
    showModalBottomSheet(
        context: context,
        builder: (c) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:      ListView(     keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag ,

              children: [
                const SizedBox(
                  height: 32,
                ),
                Text(
                  "Выберите степень образования:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                ...degrees.map((e) => ListTile(
                      trailing: _controllerDegree.text == e
                          ? const Icon(Icons.done)
                          : null,
                      title: Text(e),
                      onTap: () {
                        _controllerDegree.text = e;
                        Navigator.pop(context);
                      },
                    ))
              ],
            ),
          );
        });
  }

  List degrees = [
    'кандидат наук',
    'доктор наук',
    'доктор философии (PhD)',
    'доктор по профилю'
  ];

  void _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        FirebaseAuth.instance.currentUser?.updateEmail(_controllerEmail.text);

        final newData = model.User(
            id: FirebaseAuth.instance.currentUser!.uid,
            fullname: _controllerFullName.text,
            email: _controllerEmail.text,
            password: user?.password,
            documents: user?.documents,
            workExperience: _controllerWorkExperience.text,
            degree: _controllerDegree.text,
            role: user?.role,
            diplome: _controllerDiplome.text);


        await FirebaseFirestore.instance
            .collection('users')
            .doc(newData.id)
            .set(newData.toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль сохранен')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирования'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child:      ListView(     keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag ,

                  children: [
                    TextFormField(
                      controller: _controllerFullName,
                      decoration: const InputDecoration(labelText: 'ФИО'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your full name' : null,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _controllerEmail,
                      decoration: const InputDecoration(labelText: 'Почта'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your email' : null,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _controllerWorkExperience,
                      decoration:
                          const InputDecoration(labelText: 'Опыт работы'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _controllerDegree,
                      readOnly: true,
                      onTap: showDegrees,
                      decoration:
                          const InputDecoration(labelText: 'Академ. Степень'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _controllerDiplome,
                      decoration: const InputDecoration(labelText: 'Диплом'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text('Сохранить'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: ()async{
                      await  FirebaseAuth.instance.signOut();
                        context.pushReplacement("/auth");
                      },
                      child: const Text('Выйти из аккаунта'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
