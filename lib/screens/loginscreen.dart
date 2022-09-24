import 'package:firebase_auth_state_mngmt_test/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:bordered_text/bordered_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: ScaffoldGradientBackground(
        gradient: const LinearGradient(
          colors: [
            Color(0xffFFF3B0),
            Color(0xffCA26FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('images/chitty_chat.png'),
                width: w * 0.33,
              ),
              BorderedText(
                strokeWidth: w * 0.03,
                strokeColor: const Color(0xff37007C),
                child: Text(
                  'Chitty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // height: -2,
                    fontFamily: 'Pacifico',
                    color: Colors.white,
                    fontSize: w * 0.25,
                    shadows: [
                      BoxShadow(
                        color: const Color(0xffFF3D00).withOpacity(0.1),
                        offset: const Offset(0, 12),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              BorderedText(
                strokeWidth: w * 0.025,
                strokeColor: const Color(0xff37007C),
                child: Text(
                  'Chat',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    shadows: [
                      BoxShadow(
                        color: const Color(0xffFF3D00).withOpacity(0.1),
                        offset: const Offset(0, 12),
                        blurRadius: 3,
                      ),
                    ],
                    height: 0.8,
                    fontFamily: 'Pacifico',
                    color: Colors.white,
                    fontSize: w * 0.18,
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.05,
              ),
              InkWell(
                onTap: () async {
                  await authServices.signInWithGoogle(context);
                },
                child: Container(
                  width: w * 0.6,
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.05,
                    vertical: h * 0.015,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage('images/google.png'),
                        width: w * 0.06,
                      ),
                      SizedBox(
                        width: w * 0.02,
                      ),
                      Text(
                        'Sign In with Google',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: w * 0.04,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
