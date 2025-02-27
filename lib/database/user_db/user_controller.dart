import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:player/database/user_db/user_class.dart';
import 'package:player/database/user_db/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utility/shareprferences.dart';

class UserController extends ChangeNotifier {
  final UserServices _userServices = UserServices();
  Users? currentUser;
  List<Users>? users;

  UserController() {
    initializeCurrentUser();
  }

  Future<void> initializeCurrentUser() async {
    await getUser();
    await getAllUser();
    notifyListeners(); // Notify listeners to update UI
  }

  Future<bool> createUser({
    required String password,
    required String name,
    required String email,
    required String username,
  }) async {
    final success = await _userServices.createUser(
      name: name,
      password: password,
      email: email,
      username: username,
    );
    if (success) {
      await getUser(); // Refresh current user after creation
      notifyListeners(); // Notify listeners to update UI
    }
    return success;
  }

  Future<bool> login(String email, String password) async {
    bool success = await _userServices.login(email, password);
    if (success) {
      await getUser(); // Refresh current user after login
      notifyListeners(); // Notify listeners to update UI
    }
    return success;
  }

  Future<bool> updateUser({
    required String userId,
    String? firstName,
    String? lastName,
    DateTime? dateOfBirth,
    String? gender,
    String? email,
    String? phoneNumber,
    String? address,
    String? role,
    String? password,
    File? profile,
  }) async {
    bool success = await _userServices.updateUser(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      role: role,
      password: password,
      profile: profile,
    );
    if (success) {
      await getUser(); // Refresh current user after update
      notifyListeners(); // Notify listeners to update UI
    }
    return success;
  }

  Future<void> getUser() async {
    try {
      CustomSharePreference prefs = CustomSharePreference();
      final user = await prefs.getPreferenceValue('user');

      if (user != null) {
        final jsonDecode = json.decode(user);
        currentUser = Users.fromJson(jsonDecode);
      } else {
        currentUser = null; // Clear current user if no data is found
      }
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error fetching current user: $e');
      currentUser = null; // Clear current user on error
      notifyListeners(); // Notify listeners to update UI
    }
  }

  Future<void> getAllUser() async {
    try {
      users = await _userServices.getAllUsers();
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error fetching all users: $e');
      users = null; // Clear users list on error
      notifyListeners(); // Notify listeners to update UI
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      bool success = await _userServices.deleteUser(userId);
      if (success) {
        users?.removeWhere((user) => user.userId == userId);
        if (currentUser?.userId == userId) {
          currentUser = null; // Clear current user if deleted
        }
        notifyListeners(); // Notify listeners to update UI
      }
      return success;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      CustomSharePreference prefs = CustomSharePreference();
      await prefs.clearAllPreferences(); // Clear saved user data
      currentUser = null; // Clear current user
      notifyListeners(); // Notify listeners to update UI
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}