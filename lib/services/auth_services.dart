// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount
                .authentication; //fetches the access token and id token
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential userCredential =
              await firebaseAuth.signInWithCredential(credential);
          Navigator.pushNamedAndRemoveUntil(
              context, 'welcome', (route) => false);
        } catch (e) {
          final snackBar = SnackBar(
            content: Text(
              '$e',
              style: const TextStyle(
                color: Color(0xffFFF3B0),
                backgroundColor: Color(0xff37007C),
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // print('Sign In unsuccessful due to $e');
        }
      } else {
        final snackBar = SnackBar(
          backgroundColor: Color(0xff37007C),
          content: Text(
            'Unable to sign In',
            style: const TextStyle(
              color: Color(0xffFFF3B0),
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          '$e',
          style: const TextStyle(
            color: Color(0xffFFF3B0),
            backgroundColor: Color(0xff37007C),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
