import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:player/database/notifcation/notification_class.dart';
import 'package:player/database/notifcation/notification_services.dart';
import 'package:player/database/user_db/user_controller.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<Notifications> _notifications = [];
  List<Notifications> _allNotifications = [];
  final UserController _userController = UserController();
  List<Notifications> get notifications => _notifications;
  List<Notifications> get allNotifications => _allNotifications;
  final logger = Logger();

  NotificationController() {
    fetchNotifications();
    // fetchAllNotifications();
  }

  Future<List<Notifications>> fetchNotifications() async {
    try {
      await _userController.getUser();
      final user=_userController.currentUser;

      logger.e("this is the user name ${user!.name}");
      _notifications = await _notificationService
          .getNotifications(_userController.currentUser!.userId.toString());
      notifyListeners();
      logger.e(_notifications.toString());
      return _notifications;
    } catch (e) {
      print('Error fetching notifications: $e');
      // Handle error appropriately
      return [];
    }
  }

  Future<void> fetchAllNotifications() async {
    try {
      _allNotifications = await _notificationService.getAllNotifications();
      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
      // Handle error appropriately
    }
  }

  Future<bool> createNotification(Notifications notification) async {
    try {
      final res = await _notificationService.createNotification(
          notification: notification);
      // _notifications.add(notification);
      notifyListeners();
      fetchAllNotifications();
      return res;
    } catch (e) {
      print('Error adding notification: $e');
      // Handle error appropriately
      return false;
    }
  }


  Future<void> getNotifications(String? userId) async {
    try {
      _notifications = await _notificationService.getNotifications(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching notifications: $e');
      // You might want to handle the error more gracefully here
    }
  }

  Future<bool> updateNotification({
    required String notificationId,
    String? description,
  }) async {
    try {
      bool result = await _notificationService.updateNotification(
        notificationId: notificationId,
        description: description,
      );
      if (result) {
        notifyListeners(); // Notify listeners after updating notification
      }
      return result;
    } catch (e) {
      print('Error updating notification: $e');
      return false;
    }
  }

  Future<bool> deleteNotification(String? notificationId) async {
    try {
      bool result = await _notificationService.deleteNotification(notificationId);
      if (result) {
        notifyListeners(); // Notify listeners after deleting notification
      }
      return result;
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }

  Future<void> getAllNotifications() async {
    try {
      _notifications = await _notificationService.getAllNotifications();
      notifyListeners();
    } catch (e) {
      print('Error fetching all notifications: $e');
      // You might want to handle the error more gracefully here
    }
  }
}
