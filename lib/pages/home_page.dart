import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/auth/auth_service.dart';
import 'package:tuks_tutor_dev/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() async {
    // Get Auth Service
    final authService = AuthService();
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          // Logout Button
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      drawer:   MyDrawer(),
    );
  }
}
