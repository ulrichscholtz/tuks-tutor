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
  Future<UserCredential> signUpWithEmailPassword(String studentNr, String email, String password, String userType, String tutorSubject) async {
  try {
    // Create User
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    
    Map<String, dynamic> userData = {
      'uid': userCredential.user!.uid,
      'email': email,
      'studentnr': studentNr, 
      'usertype': userType,
    };

    if (userType == 'Tutor') {
      userData['tutoring'] = tutorSubject;
    }

    // Save user info in a separate doc
    _firestore.collection("Users").doc(userCredential.user!.uid).set(
      userData,
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

  // Delete account
  Future<void> deleteAccount() async {
    // Get current user
    User? user = getCurrentUser();
    if (user != null) {
      // Delete account from Firestore
      await _firestore.collection('Users').doc(user.uid).delete();

      // Delete account from Auth
      await user.delete();
    }
  }
}