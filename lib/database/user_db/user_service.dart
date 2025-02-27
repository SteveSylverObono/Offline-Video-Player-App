import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:player/database/user_db/user_class.dart';
import '../../../utility/shareprferences.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  Future<bool> createUser({
    required String name,
    required String password,
    required String email,
    required String username,
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user details in Firestore
      if (userCredential.user != null) {
        String userId = userCredential.user!.uid;
        await _firestore.collection('users').doc(userId).set({
          'name': name,
          'email': email,
          'username': username,
          'role': 'user', // Default role
          'userId': userId,
        });

        const snackBar = SnackBar(
          content: Text("Creation successful"),
        );
        snackBar;
        return true;
      } else {
        print('Failed to create user: User is null');
        return false;
      }
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Save user data in SharedPreferences
        CustomSharePreference prefs = CustomSharePreference();
        await prefs.saveSharepreference('user', json.encode({
          'userId': userCredential.user!.uid,
          'email': userCredential.user!.email,
        }));
        return true;
      } else {
        print('Failed to login: User is null');
        return false;
      }
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
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
    try {
      // Update user details in Firestore
      Map<String, dynamic> updates = {};
      if (firstName != null) updates['firstName'] = firstName;
      if (lastName != null) updates['lastName'] = lastName;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth.toIso8601String();
      if (gender != null) updates['gender'] = gender;
      if (email != null) updates['email'] = email;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (address != null) updates['address'] = address;
      if (role != null) updates['role'] = role;

      await _firestore.collection('users').doc(userId).update(updates);

      // Handle profile image upload (if needed)
      if (profile != null) {
        // Implement Firebase Storage for image upload here
        // Example: Upload the file to Firebase Storage and save the URL in Firestore
      }

      const snackBar = SnackBar(
        content: Text("Update successful"),
      );
      snackBar;
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      // Delete user from Firebase Authentication
      await _auth.currentUser?.delete();

      // Delete user from Firestore
      await _firestore.collection('users').doc(userId).delete();

      const snackBar = SnackBar(
        content: Text("Deletion successful"),
      );
      snackBar;
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  Future<List<Users>> getAllUsers() async {
    try {
      // Fetch all users from Firestore
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      List<Users> users = [];
      for (var doc in snapshot.docs) {
        users.add(Users.fromJson(doc.data() as Map<String, dynamic>));
      }

      print('The users are $users');
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }
}