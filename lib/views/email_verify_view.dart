import 'package:flutter/material.dart';
import 'package:todo/services/auth/firebase_auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade400,
      appBar: AppBar(
        title: const Text(
          'Verify email',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(2),
          height: 300,
          width: 400,
          child: Card(
            elevation: 10,
            margin: const EdgeInsets.only(left: 3, right: 3),
            color: Colors.blueGrey.shade200,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Please check your email and verify you email'),
                const SizedBox(
                  height: 60,
                ),
                const Text('Click below button if you did not receive email'),
                TextButton(
                  child: Container(
                    child: const Center(
                      child: Text(
                        'send again',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    height: 40,
                    width: 90,
                    color: Colors.blueGrey.shade400,
                  ),
                  onPressed: () {
                    FirebaseAuthService().getUser()!.sendEmailVerification();
                  },
                ),
                const Text(
                    'If you have already verified your email click below button , proceed to login by clicking button below'),
                TextButton(
                  child: Container(
                    child: const Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    height: 40,
                    width: 90,
                    color: Colors.blueGrey.shade400,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamed('/signin/');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
