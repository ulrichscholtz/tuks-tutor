import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P R O F I L E"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Icon(
            Icons.person,
            size: 150,
            color: Theme.of(context).colorScheme.primary,
          ),
          Center(
            child: Text(
              FirebaseAuth.instance.currentUser!.email!,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ]
      ),
    );
  }
}