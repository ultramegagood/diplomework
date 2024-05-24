import 'dart:developer';

import 'package:diplome_aisha/screens/document_upload.dart';
import 'package:diplome_aisha/screens/home_screen.dart';
import 'package:diplome_aisha/screens/login.dart';
import 'package:diplome_aisha/screens/pdf_view.dart';
import 'package:diplome_aisha/screens/profile_screen.dart';
import 'package:diplome_aisha/screens/register.dart';
import 'package:diplome_aisha/models/models.dart' as model;
import 'package:diplome_aisha/screens/user_edit.dart';
import 'package:diplome_aisha/screens/widgets/user_list.dart';
import 'package:diplome_aisha/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    if (errorDetails.context != null &&
        !errorDetails.context!
            .toDescription()
            .contains('resolving an image codec')) {
      try {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      } on Exception catch (e) {
        print(e);
      }
    }
  };
  await serviceLocatorSetup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60)))),
      darkTheme: ThemeData(
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60)))),
      routerConfig: routes,
    );
  }
}

GoRouter routes = GoRouter(
  initialLocation: '/auth',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
        path: "/auth",
        builder: (context, state) => const AuthScreen(),
        redirect: (context, state) {
          log("user is ${FirebaseAuth.instance.currentUser}");
          if (FirebaseAuth.instance.currentUser != null) {
            return "/";
          }
          return null;
        }),
    GoRoute(
      path: "/",
      builder: (context, state) => const UploadDocumentScreen(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/pdf",
      builder: (context, state) => PDFViewerScreen(
        pdfUrl: state.extra as Map<String, dynamic>,
      ),
    ),
    GoRoute(
      path: "/document",
      builder: (context, state) => const DocumentUpload(),
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfileEditPage(),
    ),
    GoRoute(
      path: "/users",
      builder: (context, state) => const UsersList(),
    ),
    GoRoute(
      path: "/user-profile",
      builder: (context, state) => UserEditScreen(
        uid: state.extra as Map<String, dynamic>,
      ),
    ),
  ],
);

