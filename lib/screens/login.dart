import 'package:diplome_aisha/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;

  String? _email;
  String? _password;

  void _login() async {
    if(_formKey.currentState?.validate() ?? false) {
      try {
      await _auth.signInWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      routes.push("/");
    } catch (e) {
        if(e.toString().contains("is incorrect")) {
          ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Неверный логин или пароль")));
        }
    }
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Авторизация'),
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
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) => _email = value,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Введите данные";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) => _password = value,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Логин'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () => context.replace("/auth"),
                      child: const Text('Регистрация'),
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
