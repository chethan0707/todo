import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/utils/utilities.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey.shade400,
        appBar: AppBar(
          title: const Text(
            'Login',
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
                      "assets/images/login2.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  radius: 100,
                ),
                const SizedBox(
                  height: 20,
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
                      email = _emailController.text;
                      password = _passwordController.text;
                      final user = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);
                      if (user.user!.emailVerified) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home/', (route) => false);
                      }
                    } on FirebaseAuthException catch (e) {
                      if (email.isEmpty || password.isEmpty) {
                        ErrorDialog().showErrorDialog(context,
                            'email and password fields cannot be empty');
                      } else {
                        ErrorDialog()
                            .showErrorDialog(context, e.message.toString());
                      }
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
                      'Login',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(
                      '/signup/',
                    );
                  },
                  child: const Text(
                    "don't have account? Register",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
