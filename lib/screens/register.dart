import 'package:diplome_aisha/models/models.dart' as model;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? _email;
  String? _password;
  String? _fullname;
  String? _workExperience;
  String? _degree;
  String? _diplome;

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
                      trailing: _degree == e ? const Icon(Icons.done) : null,
                      title: Text(e),
                      onTap: () {
                        setState(() {
                          _degree = e;
                        });
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
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );
        const role = model.Roles.teacher;
        model.User user = model.User(
          id: userCredential.user!.uid,
          fullname: _fullname!,
          email: _email!,
          password: _password!,
          documents: '',
          role: role.name,
          workExperience: _workExperience!,
          degree: _degree!,
          diplome: _diplome!,
        );

        await _firestore.collection('users').doc(user.id).set(user.toJson());
        routes.push("/");
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag ,

          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset("assets/logo.png"),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    }
                    return null;
                  },
                  onChanged: (value) => _fullname = value,
                  decoration: const InputDecoration(labelText: 'ФИО'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    }
                    return null;
                  },
                  onChanged: (value) => _email = value,
                  decoration: const InputDecoration(labelText: 'Почта'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    }
                    return null;
                  },
                  onChanged: (value) => _password = value,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    }
                    return null;
                  },
                  onChanged: (value) => _workExperience = value,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Опыт работы'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: showDegrees,
                  onChanged: (value) => _degree = value,
                  controller: TextEditingController(text: _degree),
                  decoration:
                      const InputDecoration(labelText: 'Академ. Степень'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    }
                    return null;
                  },
                  onChanged: (value) => _diplome = value,
                  decoration:
                      const InputDecoration(labelText: 'Высшее образование'),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Регистрация'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () => context.replace("/login"),
                      child: const Text('Логин'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
