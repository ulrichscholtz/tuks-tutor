import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/services/auth/login_or_register.dart';
import 'package:tuks_tutor_dev/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //User is Logged In
          if(snapshot.hasData){
            return HomePage();
          }

          //User is Not Logged In
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}