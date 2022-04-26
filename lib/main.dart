import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/views/add_view.dart';
import 'package:todo/views/email_verify_view.dart';
import 'package:todo/views/home_view.dart';
import 'package:todo/views/login_view.dart';
import 'package:todo/views/register_view.dart';

void main() {
  return runApp(
    MaterialApp(
      routes: {
        '/home/': (context) => const Home(),
        '/add/': (context) => const AddView(),
        '/signup/': (context) => const RegisterView(),
        '/signin/': (context) => const LoginView(),
        '/emailverify/': (context) => const VerifyEmailView(),
      },
      home: const RoutePage(),
    ),
  );
}

class RoutePage extends StatelessWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const Home();
                }
              }
              return const LoginView();
              
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
