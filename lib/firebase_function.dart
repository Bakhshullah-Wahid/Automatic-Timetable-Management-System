import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'provider/provider_dashboard.dart';

createUserWithEmailAndPassword(
    String emailAddress, String password, context) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    User? user = credential.user;
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Coordinator Registered successfully')));
    } else {}
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('The account already exists for that email.')));
    }
  } catch (e) {
    debugPrint('$e');
  }
}

signInWithEmailAndPassword(
    String emailAddress, String password, context, prefs2 , ref) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
 
    User? user = credential.user;

    if (user != null) {
      prefs2.setString('Email', emailAddress);   ref
                                        .read(isLoginProvider.notifier)
                                        .loginTime();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text('successfully logged in'))));
      return;
    }
  } on FirebaseAuthException catch (e) {
   

    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('No user found for that email.')));
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Wrong password provided for that user.')));
    }
  }
}
