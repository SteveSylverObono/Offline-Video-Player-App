import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw e;
    }
  }

  // Create account with email and password
  Future<UserCredential> createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create default user preferences
      await _createUserPreferences(credential.user!.uid);
      
      return credential;
    } catch (e) {
      throw e;
    }
  }

  // Create default user preferences
  Future<void> _createUserPreferences(String userId) async {
    final preferences = UserPreferences(userId: userId);
    await _firestore
        .collection('user_preferences')
        .doc(userId)
        .set(preferences.toMap());
  }

  // Get user preferences
  Future<UserPreferences> getUserPreferences() async {
    if (currentUser == null) throw Exception('No user logged in');
    
    final doc = await _firestore
        .collection('user_preferences')
        .doc(currentUser!.uid)
        .get();
    
    if (!doc.exists) {
      await _createUserPreferences(currentUser!.uid);
      return UserPreferences(userId: currentUser!.uid);
    }
    
    return UserPreferences.fromMap(doc.data()!);
  }

  // Update user preferences
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    if (currentUser == null) throw Exception('No user logged in');
    
    await _firestore
        .collection('user_preferences')
        .doc(currentUser!.uid)
        .update(preferences.toMap());
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
