
import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/components/user_tile.dart';
import 'package:tuks_tutor_dev/services/auth/auth_service.dart';
import 'package:tuks_tutor_dev/services/chat/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  // Chat & Auth services
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  // Show confirm unblock box
  void _showUnblockBox(BuildContext context, String userID) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Unblock User"),
      content: const Text("Are you sure you want to unblock this user?"),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        // Unblock button
        TextButton(
          onPressed: () {
            chatService.unblockUser(userID);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User unblocked!"),
              ),
            );
          },
          child: const Text("Unblock"),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    
    // Get current user ID
    String userID = authService.getCurrentUser()!.uid;

    // Stream blocked users
    return Scaffold(
      appBar: AppBar(
        title: Text("B L O C K E D  U S E R S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService
            .getBlockedUserStream(userID),
        builder: (context, snapshot) {
          final blockedUsers = snapshot.data ?? [];

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          // No users
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("No blocked users."),
            );
          }
          
          // Error
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          }
          
          // Load complete
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user["email"].split('@')[0], 
                onTap: () => _showUnblockBox(context, user['uid']),
              );
            },
          );
        }
      ) 
    );
  }
}