import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/foundation.dart';

class AuthenticationFunctions {
  FirebaseAuth fireAuth = FirebaseAuthForAll.instance;
  String getUserId() {
    User user;
    try {
      user = fireAuth.currentUser!;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return "";
    }
    return user.uid;
  }

  User? getUser() {
    return fireAuth.currentUser;
  }

  Future<String> login(String email, String password) async {
    String report = '';
    try {
      await fireAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        report = "done";
      });
    } on FirebaseAuthException catch (e) {
      report = e.code;
    }
    return report;
  }

  Future<String> creatAccount(String email, String password) async {
    String report = "";

    try {
      await fireAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        var users = FirestoreForAll.instance.collection('users');

        if (value.user != null) {
          users.doc(value.user!.uid).set({'userName': 'alhgannam'});
          report = "done";
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        report = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        report = 'The account already exists for that email.';
      } else {
        report = e.code;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return report;
  }

  logout() async {
    fireAuth.signOut();
    return "done";
  }
}
