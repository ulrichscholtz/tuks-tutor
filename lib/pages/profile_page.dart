import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("P R O F I L E"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Icon(
            Icons.person,
            size: 150,
            color: Theme.of(context).colorScheme.primary,
          ),
          Center(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore.collection("Users").doc(_auth.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            snapshot.data!["usertype"],
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (snapshot.data!["usertype"] == "Tutor")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("What are you tutoring?", style: TextStyle(fontSize: 16)),
                                SizedBox(width: 16),
                                DropdownButton<String>(
                                  value: snapshot.data!["tutoring"],
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _firestore.collection("Users").doc(_auth.currentUser!.uid).update({
                                          "tutoring": newValue,
                                        });
                                      });
                                    }
                                  },
                                  items: <String>['INL', 'OBS', 'PUB']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          const SizedBox(height: 10),
                          Text(
                            snapshot.data!["studentnr"],
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  child: Text(
                    _auth.currentUser!.email!,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
