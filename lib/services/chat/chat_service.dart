import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuks_tutor_dev/models/message.dart';

class ChatService {

  // Get instance of Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all users stream
  Stream<List<Map<String,dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Go through each individual user
        final user = doc.data();

        // Return user
        return user;
      }).toList();
    });
  }

  // Get all users EXCEPT blocked users stream
  Stream<List<Map<String,dynamic>>> getUsersStreamExludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
          // Get blocked user IDs
          final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();

          // Get all users
          final usersSnapshot = await _firestore.collection('Users').get();

          // Return as stream list, excluding current & blocked users
          return usersSnapshot.docs
          .where((doc) => 
              doc.data()['email'] != currentUser.email && 
              !blockedUserIDs.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  // Send messages
  Future<void> sendMessage(String receiverID, message) async {
    // Get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp
    );

    // Construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // Sort the ids (ensures chatroom ID is same for any 2 people)
    String chatRoomID = ids.join('_');

    // Add new message to database
    await _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct chat room ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .orderBy("timestamp", descending: false)
    .snapshots();
  }

  // Report user
  Future<void> reportUser(String messageID, String userID) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy' : currentUser!.uid,
      'messageID' : messageID,
      'messageOwnerID' : userID,
      'timestamp' : FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  // Block user
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userID)
        .set({});
  }
  // Unblock user
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserID)
        .delete();
  }

  // Get blocked user stream
  Stream<List<Map<String, dynamic>>> getBlockedUserStream(String userID) {
    return _firestore
        .collection('Users')
        .doc(userID)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // Get list of blocked user IDs
      final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUserIDs.map((id) => _firestore.collection('Users').doc(id).get()),
      );

      // Return as list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
