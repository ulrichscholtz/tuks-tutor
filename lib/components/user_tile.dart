import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String userType; // Add a new parameter to accept the user type

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.userType, // Make the parameter required
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(40),
          ),
          margin: EdgeInsets.symmetric(vertical: 7),
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: userType == 'Tutor' ? Color(0xFF005BAB) : Color(0xFFDF3840), // Set the avatar color based on the user type
                child: Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 20,),
              // Username
              Text(
                text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


