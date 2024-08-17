import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/services/chat/chat_service.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageID;
  final String userID;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageID,
    required this.userID,
  });

  // Show options
  void _showOptions(BuildContext context, String messageID, String userID) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Report button
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Report'),
                onTap: () {
                  // Report message
                  Navigator.pop(context);
                  _reportContent(context, messageID, userID);
                },
              ),
              // Block button
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block User'),
                onTap: () {
                  // Block user
                  Navigator.pop(context);
                  _BlockUser(context, userID);
                },
              ),
              // Cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // Report message
  void _reportContent(BuildContext context, String messageID, String userID) {
    showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: const Text('Report Content'),
        content: const Text('Are you sure you want to report this message?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ChatService().reportUser(messageID, userID);
              // Report content
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Message Reported!'),
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  // Block user
  void _BlockUser(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure you want to block this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ChatService().blockUser(userID);
              // Block user
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User Blocked!'),
                ),
              );
            },
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // Show options
          _showOptions(context, messageID, userID);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? Color(0xFFDF3840)
              : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}