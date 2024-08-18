import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuks_tutor_dev/services/auth/auth_gate.dart';
import 'package:tuks_tutor_dev/firebase_options.dart';
import 'package:tuks_tutor_dev/services/notifications/notification_service.dart';
import 'package:tuks_tutor_dev/themes/light_mode.dart';

void main() async {
  // SETUP FIREBASE
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());

  // SETUP NOTIFICATION HANDLER
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // REQUEST PERMISSIONS
  final noti = NotificationService();
  await noti.requestPermission();
  noti.setupInteractions();
}

// NOTIFICATION BACKGROUND HANDLER
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
  print('Message notification: ${message.notification?.body}');
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