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
  bool _showAll = true;
  bool _showTutors = false;
  bool _showStudents = false;
  bool _showINL = false;
  bool _showOBS = false;
  bool _showPUB = false;

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
            child: Row(
              children: [
                Expanded(
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
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Filter Users'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CheckboxListTile(
                                value: _showAll,
                                onChanged: (value) {
                                  setState(() {
                                    _showAll = true;
                                    _showTutors = false;
                                    _showStudents = false;
                                    _showINL = false;
                                    _showOBS = false;
                                    _showPUB = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('All'),
                              ),
                              CheckboxListTile(
                                value: _showTutors,
                                onChanged: (value) {
                                  setState(() {
                                    _showTutors = true;
                                    _showStudents = !_showTutors;
                                    _showAll = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('Tutors'),
                              ),
                              CheckboxListTile(
                                value: _showStudents,
                                onChanged: (value) {
                                  setState(() {
                                    _showStudents = true;
                                    _showTutors = !_showStudents;
                                    _showAll = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('Students'),
                              ),                              
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.filter_list_outlined),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Filter Modules'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CheckboxListTile(
                                value: _showAll,
                                onChanged: (value) {
                                  setState(() {
                                    _showAll = true;
                                    _showINL = false;
                                    _showOBS = false;
                                    _showPUB = false;
                                    _showStudents = false;
                                    _showTutors = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('All'),
                              ),
                              CheckboxListTile(
                                value: _showINL,
                                onChanged: (value) {
                                  setState(() {
                                    _showAll = false;
                                    _showINL = true;
                                    _showOBS = false;
                                    _showPUB = false;
                                    _showStudents = false;
                                    _showTutors = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('INL Tutors'),
                              ),
                              CheckboxListTile(
                                value: _showOBS,
                                onChanged: (value) {
                                  setState(() {
                                    _showAll = false;
                                    _showINL = false;
                                    _showOBS = true;
                                    _showPUB = false;
                                    _showStudents = false;
                                    _showTutors = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('OBS Tutors'),
                              ),
                              CheckboxListTile(
                                value: _showPUB,
                                onChanged: (value) {
                                  setState(() {
                                    _showAll = false;
                                    _showINL = false;
                                    _showOBS = false;
                                    _showPUB = true;
                                    _showStudents = false;
                                    _showTutors = false;
                                  });
                                  Navigator.pop(context);
                                },
                                title: const Text('PUB Tutors'),
                              ),                              
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.view_module_outlined),
                ),
              ],
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
                  } else {
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
      .where((user) {
        if (_showAll) {
          return true;
        } else if (_showTutors) {
          return user["usertype"] == "Tutor";
        } else if (_showStudents) {
          return user["usertype"] == "Student";
        } else if (_showINL) {
          return user["tutoring"] == "INL";
        } else if (_showOBS) {
          return user["tutoring"] == "OBS";
        } else if (_showPUB) {
          return user["tutoring"] == "PUB";
        }
        return false;
      })
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
      String userText = '${userData['studentnr']} | ${userData['email'].split('@')[0]}';
      if (userData["usertype"] == "Tutor") {
        userText += ' | ${userData['tutoring']} Tutor';
      }

      return UserTile(
        text: userText,
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
        },
        userType: userData["usertype"],
      );
    } else {
      return Container();
    }
  }
}


