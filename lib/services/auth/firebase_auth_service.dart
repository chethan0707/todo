import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  final _firebase = FirebaseAuth.instance;
  FirebaseAuth getInstance() {
    return _firebase;
  }

  User? getUser() {
    return _firebase.currentUser;
  }

  User? signIn(String email, String password) {
    try {


      _firebase.signInWithEmailAndPassword(email: email, password: password);
      return getUser();
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
    }
    return null;
  }

  Future<User?> createUser(String email, String password) async {
    var res = await _firebase.createUserWithEmailAndPassword(
        email: email, password: password);
    return res.user;
  }
}
