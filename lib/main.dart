import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuks_tutor_dev/services/auth/auth_gate.dart';
import 'package:tuks_tutor_dev/firebase_options.dart';
import 'package:tuks_tutor_dev/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: lightTheme,
    );
  }
}