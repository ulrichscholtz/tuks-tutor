import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tuks_tutor_dev/pages/login_page.dart';
import 'package:tuks_tutor_dev/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  final PageController _pageController = PageController();

  // Initially, show Login Page
  bool showLoginPage = true;

  // Toggles between Login and Register Page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
      _pageController.animateToPage(
          showLoginPage ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
      children: [
        LoginPage(
          onTap: togglePages,
        ),
        RegisterPage(
          onTap: togglePages,
        ),
      ],
    );
  }
}
