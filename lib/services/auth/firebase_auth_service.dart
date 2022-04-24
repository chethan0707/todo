// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart'
//     show FirebaseAuthException, FirebaseAuth;
// import 'package:todo/entities/user.dart';

// class UserNotLoggedInException implements Exception {}

// class FirebaseAuthService {
//   User getUser() {
//     try {
//       var user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw UserNotLoggedInException();
//       } else {
//         return User(email: user.email, isEmailVerified: user.emailVerified);
//       }
//     } on FirebaseAuthException catch (e) {
//       log(e.message.toString());
//       throw UserNotLoggedInException();
//     }
//   }
// }
