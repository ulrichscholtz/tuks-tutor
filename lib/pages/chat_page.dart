import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/components/chat_bubble.dart';
import 'package:tuks_tutor_dev/components/my_textfield.dart';
import 'package:tuks_tutor_dev/services/auth/auth_service.dart';
import 'package:tuks_tutor_dev/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Text controller
  final TextEditingController _messageController = TextEditingController();

  // Chat & Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Text field focus
  FocusNode myFocusNode = FocusNode();

  // Scroll controller
  final ScrollController _scrollController = ScrollController();
  void ScrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();

    // Add listener to the focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Add keyboard delay
        // Calculate amount of remaining space
        // Scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          () => ScrollDown(),
        );
      }
    });

    // Scroll down to the new maximum after every message
    Future.delayed(const Duration(milliseconds: 500), () {
      ScrollDown();
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus text field
        myFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Text(
                      widget.receiverEmail.split('@')[0],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '|',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.receiverID)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!['usertype'],
                            style: const TextStyle(fontSize: 18),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
        ),
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
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      // Get messages
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        // Errors
        if (snapshot.hasError) {
          return const Text("Error loading messages.");
        }

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(),
            );
        }

        // Return list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
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
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            messageID: doc.id,
            userID: data["senderID"],
          )
        ],
      ),
    );
  }

  // Build user input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          // Textfield should take most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message...",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // Send button
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFDF3840),
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: () {
                sendMessage();
              },
              icon: Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Send message
  void sendMessage() async {
    // If there is something typed
    if (_messageController.text.isNotEmpty) {
      // Send the message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      // Clear the text controller
      _messageController.clear();

      // Scroll down to the new maximum after every message
      Future.delayed(const Duration(milliseconds: 500), () {
        ScrollDown();
      });
    }
  }
}



