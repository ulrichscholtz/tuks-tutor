import "package:flutter/material.dart";
import "package:tuks_tutor_dev/pages/home_page.dart";
import "package:tuks_tutor_dev/pages/users_page.dart";
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
                  child: Image.asset('lib/images/drawer.png'),
                  widthFactor: 0.8,
                ),
              ),

              const SizedBox(height: 20,),

              //Home List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("C H A T S"),
                  leading: const Icon(Icons.account_box_rounded),
                  onTap: () {
                    //Pop the Drawer
                    Navigator.pop(context);

                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      )
                    );
                  },
                ),
              ),

               Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("S E A R C H  U S E R S"),
                  leading: const Icon(Icons.search),
                  onTap: () {
                    //Pop the Drawer
                    Navigator.pop(context);

                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => UsersPage(),
                      )
                    );
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
