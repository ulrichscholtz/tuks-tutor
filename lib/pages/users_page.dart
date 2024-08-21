import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/components/user_tile.dart';
import 'package:tuks_tutor_dev/pages/chat_page.dart';
import 'package:tuks_tutor_dev/services/auth/auth_service.dart';
import 'package:tuks_tutor_dev/services/chat/chat_service.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key});

  // Chat & Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService =AuthService();

  void logout() async {
    // Get Auth Service
    final authService = AuthService();
    await authService.signOut();
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UsersPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S E A R C H  U S E R S"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "Search...",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                setState(() {});
              },
              child: StreamBuilder(
                stream: widget._chatService.getUsersStreamExludingBlocked(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return _buildUserList(snapshot.data!);
                  } 
                  
                  // Loading...
                  if(snapshot.connectionState == ConnectionState.waiting) {
                   return const Center(
                      child: CircularProgressIndicator(),
                    );
        }
                  else {
                    return Center(
                      child: Text(
                        "N O  U S E R S  F O U N D",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build User List NOT Logged In User
  Widget _buildUserList(List<Map<String, dynamic>> users) {
    // Filter users by search text
    final search = _searchController.text.toLowerCase();
    final filteredUsers = users
      .where((user) => user["email"].toLowerCase().contains(search) ||
          user["studentnr"].toLowerCase().contains(search))
      .toList();

    return ListView(
      children: filteredUsers
        .map<Widget>((userData) => _buildUserListItem(userData, context))
        .toList(),
    );
  }
  // Build User List Item
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // Display all users except current logged in user
    if (userData["email"] != widget._authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['studentnr'] + ' | ' + userData['email'].split('@')[0],
        onTap: () {
          // Tapped on user, go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),  
          );
        }
      );
    } else {
      return Container();
    }
  }
}



