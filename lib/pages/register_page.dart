import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuks_tutor_dev/services/auth/auth_service.dart';
import 'package:tuks_tutor_dev/components/my_button.dart';
import 'package:tuks_tutor_dev/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;


  RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final TextEditingController _studentNrController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController =TextEditingController();

  final TextEditingController _confirmPwController =TextEditingController();

  String _selectedUserType = 'Student';
  bool _showDropDown = false;
  String _selectedCourse = 'INL';

  //Register Method
  void register(BuildContext context) {
    // Get Auth Service
    final authService = AuthService();

    // Check that all fields are filled
    if (/*ToDo: _studentNrController.text.isEmpty || */_emailController.text.isEmpty || _pwController.text.isEmpty || _confirmPwController.text.isEmpty) {
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
            "All fields must be filled in.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 16,
            ),
          ),
        ),
      );
      return;
    }

    // If passwords match -> get user
    if (_pwController.text == _confirmPwController.text && _studentNrController.text.length >= 8) {
      // Check that all fields are filled
      try {
        String userType = _selectedUserType == 'Student' ? 'Student' : 'Tutor';
        String tutorSubject = _selectedCourse;
        authService.signUpWithEmailPassword(_studentNrController.text, _emailController.text, _pwController.text, userType, tutorSubject);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    if (_pwController.text != _confirmPwController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Passwords don't match",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Please try again",
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 16,
            ),
          ),
        ),
      );
    }else if (_studentNrController.text.length < 8) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Student Number must be 8 digits long.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              "Student number too short",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
              ),
            ),
          ),
        );
        return;
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
              Icon(Icons.account_circle, size: 125, color: Color(0xFF005BAB)),

              const SizedBox(height: 15),

              // Welcome Message
              Text(
                "Let's create an account for you.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButtons(
                    onPressed: (index) {
                      setState(() {
                        _selectedUserType = index == 0 ? 'Student' : 'Tutor';
                        _showDropDown = _selectedUserType == 'Tutor';
                      });
                    },
                    isSelected: [_selectedUserType == 'Student', _selectedUserType == 'Tutor'],
                    children: [
                      Icon(Icons.school_outlined, size: 24),
                      Icon(Icons.supervisor_account_outlined, size: 24),
                    ],
                  ),
                  SizedBox(width: 16),
                  Text(_selectedUserType, style: TextStyle(fontSize: 16)),
                ],
              ),
              Visibility(
                visible: _showDropDown,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("What are you tutoring?", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedCourse,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCourse = newValue;
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
                ),
              ),

              const SizedBox(height: 25),
              
              // Student Number Textfield
              MyTextField(
                obscureText: false,
                hintText: "Student Number",
                controller: _studentNrController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
              ),
              
              const SizedBox(height: 10),

              // Email Textfield
              MyTextField(
                obscureText: false,
                hintText: "Email",
                controller: _emailController,
              ),

              const SizedBox(height: 10),
              
              // Password Textfield
              MyTextField(
                obscureText: true,
                hintText: "Password",
                controller: _pwController,
              ),

              const SizedBox(height: 10),

              // Confirm Password Textfield
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPwController,
              ),

              const SizedBox(height: 25),

              // Login Button
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),

              const SizedBox(height: 25),

              // Register Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login now",
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


