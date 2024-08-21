import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/components/my_settings_list_tile.dart';
import 'package:tuks_tutor_dev/pages/blocked_users_page.dart';
import 'package:tuks_tutor_dev/pages/profile_page.dart';
import 'package:tuks_tutor_dev/services/auth/auth_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

 // User account deletion method
  Future<void> userWantsToDeleteAccount(BuildContext context) async {

    // Store user's decision in this boolean
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: [
            // Cancel Button
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(false),
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.background),),
            ),
            // Confirm Button
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(true),
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Text(
                "Delete",
                style: TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        );
      },
    ) ?? false;

    // If the user confirms, delete their account
    if (confirm) {
      try {
        Navigator.pop(context);
        await AuthService().deleteAccount();
      } catch (e) {
        // Handle any errors
      }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S E T T I N G S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          children: [
            // Profile Page
            MySettingsListTile(
              icon: Icon(Icons.person, color: Theme.of(context).colorScheme.inversePrimary),
              title: "My Profile",
              textColor: Theme.of(context).colorScheme.inversePrimary,
              action:  IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            // Blocked Users
            MySettingsListTile(
              icon: Icon(Icons.block, color: Theme.of(context).colorScheme.inversePrimary),
              title: "Blocked Users",
              textColor: Theme.of(context).colorScheme.inversePrimary,
              action:  IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockedUsersPage(),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              color: Theme.of(context).colorScheme.secondary,
            ),
            // Delete Account
            MySettingsListTile(
              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.tertiary),
              title: "Delete Account", 
              textColor: Theme.of(context).colorScheme.tertiary,
              action: IconButton(
                onPressed: () => userWantsToDeleteAccount(context),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              color: Colors.red.shade400,),
          ],
        ),
      ),
    );
  }
}