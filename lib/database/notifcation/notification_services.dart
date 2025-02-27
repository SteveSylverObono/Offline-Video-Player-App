import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:player/database/notifcation/notification_class.dart';

class NotificationService {
  final Logger logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a notification
  Future<bool> createNotification({required Notifications notification}) async {
    try {
      await _firestore.collection('notifications').add(notification.toJson());
      logger.i("Notification created successfully");
      return true;
    } catch (e) {
      logger.e('Error creating notification: $e');
      return false;
    }
  }

  // Fetch notifications for a specific user
  Future<List<Notifications>> getNotifications(String? userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      List<Notifications> notifications = querySnapshot.docs
          .map((doc) => Notifications.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      logger.i("Notifications fetched successfully");
      return notifications;
    } catch (e) {
      logger.e('Error getting notifications: $e');
      return [];
    }
  }

  // Update a notification
  Future<bool> updateNotification({
    required String notificationId,
    String? description,
  }) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        if (description != null) 'description': description,
      });
      logger.i("Notification updated successfully");
      return true;
    } catch (e) {
      logger.e('Error updating notification: $e');
      return false;
    }
  }

  // Delete a notification
  Future<bool> deleteNotification(String? notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
      logger.i("Notification deleted successfully");
      return true;
    } catch (e) {
      logger.e('Error deleting notification: $e');
      return false;
    }
  }

  // Fetch all notifications
  Future<List<Notifications>> getAllNotifications() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('notifications').get();

      List<Notifications> notifications = querySnapshot.docs
          .map((doc) => Notifications.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      logger.i("All notifications fetched successfully");
      return notifications;
    } catch (e) {
      logger.e('Error fetching all notifications: $e');
      return [];
    }
  }
}
