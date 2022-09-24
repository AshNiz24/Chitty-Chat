// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:async';

import 'screens/loginscreen.dart';
import 'services/auth_services.dart';
import 'screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/message_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // var k = FirebaseAuth.instance.signInWithCredential(credential);

  runApp(FirstScreen());
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  AuthServices authServices = AuthServices();
  User? currentUser;
  @override
  void initState() {
    // TODO: implement initState
    currentUser = authServices.firebaseAuth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xffCA26FF),
          colorScheme: ColorScheme.fromSwatch(
              primaryColorDark: Color(0xffFFF3B0),
              accentColor: Color(0xff37007C))),
      debugShowCheckedModeBanner: false,
      initialRoute: currentUser == null ? 'login' : 'welcome',
      routes: {
        'login': (context) => LoginScreen(),
        'welcome': (context) => WelcomeScreen(),
      },
    );
  }
}
