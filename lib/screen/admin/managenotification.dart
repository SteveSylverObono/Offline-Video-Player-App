

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:player/database/notifcation/notification_class.dart';
import 'package:player/database/notifcation/notification_controller.dart';
import 'package:player/database/user_db/user_controller.dart';

@RoutePage(name: 'ManageNotificationRoute')
class ManageNotificationScreen extends StatefulWidget {
  const ManageNotificationScreen({Key? key}) : super(key: key);

  @override
  _ManageNotificationScreenState createState() =>
      _ManageNotificationScreenState();
}

class _ManageNotificationScreenState extends State<ManageNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? userId;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Dashboard'),
        centerTitle: true,
      ),
      body: Consumer<NotificationController>(
        builder: (context, notificationController, child) {
          final notifications = notificationController.allNotifications;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(notification.title ?? ''),
                  subtitle: Text(notification.description ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteNotification(
                            context, notificationController, notification.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNotificationDialog(context,
            Provider.of<NotificationController>(context, listen: false)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showNotificationDialog(
      BuildContext context, NotificationController notificationController,
      {Notifications? notification}) async {
    _titleController.text = notification?.title ?? '';
    _messageController.text = notification?.description ?? '';
    final logger = Logger();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification == null
            ? 'Create Notification'
            : 'Update Notification'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a message' : null,
              ),
              Consumer<UserController>(
                builder: (context, userController, child) {
                  return DropdownButtonFormField<String>(
                    value: userId == null ? 'all' : userId,
                    decoration: const InputDecoration(labelText: 'Select User'),
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Users'),
                      ),
                      ...userController.users?.map((user) {
                            return DropdownMenuItem(
                              value: user.userId,
                              child: Text(user.name ?? 'Unknown'),
                            );
                          }) ??
                          [],
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        logger.e(newValue);
                        userId = newValue == 'all' ? null : newValue;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newNotification = Notifications(
                  userId: userId,
                  title: _titleController.text,
                  description: _messageController.text,
                  date: DateTime.now().toString(),
                );

                bool success;
                if (notification == null) {
                  success = await notificationController
                      .createNotification(newNotification);
                  if (success) {
                    await _sendNotification(newNotification);
                  }
                } else {
                  // success = await notificationController.updateNotification(
                  //     notification.id.toString(), newNotification);
                  success = true;
                }

                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Notification ${notification == null ? 'created' : 'updated'} successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to save notification')),
                  );
                }
              }
            },
            child: Text(notification == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendNotification(Notifications notification) async {
    // final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // if (userId == null) {
    //   await messaging.sendMessage(
    //     data: {
    //       'title': notification.title ?? '',
    //       'body': notification.description ?? '',
    //     },
    //   );
    // } else {
    //   await messaging.sendMessage(
    //     to: userId!,
    //     data: {
    //       'title': notification.title ?? '',
    //       'body': notification.description ?? '',
    //     },
    //   );
    // }
  }

  Future<void> _deleteNotification(BuildContext context,
      NotificationController notificationController, String? id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await notificationController.deleteNotification(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete notification')),
        );
      }
    }
  }
}
