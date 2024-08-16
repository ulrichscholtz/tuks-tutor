import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/components/chat_bubble.dart';
import 'package:tuks_tutor_dev/components/my_textfield.dart';
import 'package:tuks_tutor_dev/services/auth/auth_service.dart';
import 'package:tuks_tutor_dev/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Send message
  void sendMessage() async {
    // If there is something typed
    if(_messageController.text.isNotEmpty) {
      // Send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // Clear the text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          // Display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // Display user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // Errors
        if(snapshot.hasError) {
          return const Text("Error");
        }

        // Loading
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // Return list view
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }
  // Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // Align messages to the right if sender is current user, otherwise left
    var alignment = 
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;


    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(message: data["message"], isCurrentUser: isCurrentUser,)
        ],
      ),
    );
  }

  // Build user input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          // Textfield should take most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message...",
              obscureText: false,
            )
          ),
      
          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFDF3840),
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}