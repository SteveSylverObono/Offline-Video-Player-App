import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:player/database/user_db/user_controller.dart';
import 'package:player/database/user_db/user_class.dart';

@RoutePage(name: 'UsersDashboardRoute')
class UsersDashboardScreen extends StatefulWidget {
  const UsersDashboardScreen({Key? key}) : super(key: key);

  @override
  _UsersDashboardScreenState createState() => _UsersDashboardScreenState();
}

class _UsersDashboardScreenState extends State<UsersDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Dashboard'),
        centerTitle: true,
      ),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          if (userController.users == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: userController.users!.length,
            itemBuilder: (context, index) {
              final user = userController.users![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.name ?? ''),
                  subtitle: Text(user.email ?? ''),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuSelection(value, user, userController),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
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
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleMenuSelection(
      String value, Users user, UserController userController) {
    switch (value) {
      case 'edit':
        _showEditUserDialog(context, user, userController);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context, user, userController);
        break;
    }
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    // Implement add user dialog
  }

  Future<void> _showEditUserDialog(
      BuildContext context, Users user, UserController userController) async {
    // Implement edit user dialog
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Users user, UserController userController) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${user.name}?'),
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
      final success = await userController.deleteUser(user.userId ?? '');
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete user')),
        );
      }
    }
  }
}
