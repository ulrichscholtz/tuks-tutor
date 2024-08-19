import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_tutor_dev/services/notifications/notification_service.dart';

class AuthService {
  // Instance of Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // Sign in user
      UserCredential userCredential = 
        await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
      
      // Save user info in a seperate doc if user does not exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
        SetOptions(merge: true),
      );

      // Save device token
      NotificationService().setupTokenListeners();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  // Sign Up
  Future<UserCredential> signUpWithEmailPassword(String studentnr, email, password) async {
    try {
      // Create User
      UserCredential userCredential = 
        await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      
      // Save user info in a seperate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
          'studentnr': studentnr, 
        }
      );

      // Save device token
      NotificationService().setupTokenListeners();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    // Get current user
    String? userID = _auth.currentUser?.uid;
    // To clear current user token
    if (userID != null) {
      await NotificationService().clearTokenOnLogout(userID);
    }
    return await _auth.signOut();
  }

  // Errors
  
}