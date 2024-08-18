const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { event } = require('firebase-functions/v1/analytics');
admin.initializeApp();


// Send notification on new message
exports.sendNotificationOnMessage = functions.firestore
  .document('chat_rooms/{chatRoomID}/messages/{messageID}')
  .onCreate(async (snapshot, context) => {
    const message = snapshot.data();

    try {
      const receiverDoc = await admin.firestore().collection('Users').doc(message.receiverID).get();
      if (!receiverDoc.exists) {
        console.log('Receiver does not exist.');
        return null;
      }

      const receiverData = receiverDoc.data();
      const token = receiverData.fcmToken;

      if (!token) {
        console.log('No token for user, cannot send notification.');
        return null;
      }
      // Updated message payload for 'send' method
      const messagePayload = {
        token: token,
        notification: {
          title: message.senderEmail.split('@')[0],
          body: message.message,
        },
        
        android: {
          notification: {
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
          }
        },
        apns: {
          payload: {
            aps: {
              category: 'FLUTTER_NOTIFICATION_CLICK'
            }
          }
        },
      };
      // Send notification
      const response = await admin.messaging().send(messagePayload);
      console.log('Notification sent successfully.', response);
      return response;
    } catch (error) {
      console.error('Detailed error: ', error);
      if (error.code && error.message) {
        console.error('Error code: ', error.code);
        console.error('Error message: ', error.message);
      }
      throw new Error('Failed to send notification.');
    }
});

