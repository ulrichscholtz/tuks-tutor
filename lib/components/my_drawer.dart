import "package:flutter/material.dart";
import "package:tuks_tutor_dev/pages/settings_page.dart";

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Logo
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

              //Home List Tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text("H O M E"),
                  leading: Icon(Icons.home),
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
                  title: Text("S E T T I N G S"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    //Pop the Drawer
                    Navigator.pop(context);

                    //Navigate to Settings Page
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
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
              title: Text("L O G O U T"),
              leading: Icon(Icons.logout),
              onTap: () {},
            ),
          )
        ],
      ),
    );
  }
}
