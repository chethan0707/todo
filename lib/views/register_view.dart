import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:todo/utils/utilities.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late String email;
  late String password;

  @override
  void initState() {
    _emailController.addListener(() {
      email = _emailController.text;
    });
    _passwordController.addListener(() {
      password = _passwordController.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();

    // if (FirebaseAuth.instance.currentUser!.emailVerified) {
    //   Navigator.of(context).pushNamedAndRemoveUntil('/home/', (route) => false);
    // }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey.shade400,
        appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/login.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  radius: 125,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(color: Colors.black),
                    ),
                    hintText: 'Enter email',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    label: Text(
                      'password',
                      style: TextStyle(color: Colors.black),
                    ),
                    hintText: 'Enter password',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      var user = await FirebaseAuthService()
                          .createUser(email, password);
                      http.post(
                        Uri.parse("http://localhost:8080/todo/user/add"),
                        body: jsonEncode({
                          "_id": "",
                          "email": email,
                          "userName": email,
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );
                      if (user != null) {
                        await user.sendEmailVerification();
                        Navigator.of(context).pushNamed('/emailverify/');
                      }
                    } on FirebaseAuthException catch (e) {
                      await ErrorDialog()
                          .showErrorDialog(context, e.message.toString());
                      // await showErrorDialog(context, e.message.toString());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey.shade500),
                    height: 70,
                    width: 200,
                    child: const Center(
                        child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signin/');
                  },
                  child: const Text(
                    'Already registered? Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
