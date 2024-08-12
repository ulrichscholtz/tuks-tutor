import 'package:flutter/material.dart';
import 'package:tuks_tutor_dev/auth/auth_service.dart';
import 'package:tuks_tutor_dev/components/my_button.dart';
import 'package:tuks_tutor_dev/components/my_textfield.dart';

class LoginPage extends StatelessWidget {

  //Text Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController =TextEditingController();

  //Tap for Register
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  //Login Method
  void login(BuildContext context) async {
    // Auth Service
    final authService = AuthService();

    // Try Login
    // Check that all fields are filled
    if (_emailController.text.isEmpty || _pwController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Empty fields.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Email or Password is empty.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 16,
            ),
          ),
        ),
      );
      return;
    }

    // Try Login
    try {
      await authService.signInWithEmailPassword(_emailController.text, _pwController.text);
    }

    // Catch Errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Email or Password is incorrect.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Please try again.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 16,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.menu_book,
                size: 120,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 50),

              // Welcome Message
              Text(
                "Tuks Tutor",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),

              const SizedBox(height: 25),

              // Email Textfield
              MyTextField(
                obscureText: false,
                hintText: "Email",
                controller: _emailController,
              ),

              const SizedBox(height: 10),

              // Password Textfield
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),

              const SizedBox(height: 25),

              // Login Button
              MyButton(
                text: "Login",
                onTap: () => login(context),
              ),

              const SizedBox(height: 25),

              // Register Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
