import "package:flutter/material.dart";
import "package:tuks_tutor_dev/services/auth/auth_service.dart";
import "package:tuks_tutor_dev/pages/settings_page.dart";

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // Logout Method
  void logout() {
    // Get Auth Service
    final authService = AuthService();

    // Logout
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Logo
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.primary,
                    size: 100,
                  ),
                ),
              ),

              //Home List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    //Pop the Drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              //Settings List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E T T I N G S"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    //Pop the Drawer
                    Navigator.pop(context);

                    //Navigate to Settings Page
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      )
                    );
                  },
                ),
              ),
            ],
          ),
          //Logout List Tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],
      ),
    );
  }
}
