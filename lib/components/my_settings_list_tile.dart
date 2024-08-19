import 'package:flutter/material.dart';

class MySettingsListTile extends StatelessWidget {
  const MySettingsListTile({
    required this.title,
    required this.action,
    required this.color,
    required this.textColor,
    super.key
  });

  final String title;
  final Widget action;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(
                left: 25, top: 10, right: 25
              ),
              padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  // Action
                  action,
                ],
              ),
            );
  }
}

 