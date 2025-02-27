
import 'package:logger/logger.dart';
import 'package:player/database/history/history_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger();

  // Fetch history by user ID
  Future<List<History>> getHistoryByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('histories')
          .where('userId', isEqualTo: userId)
          .get();

      List<History> histories = querySnapshot.docs
          .map((doc) => History.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      logger.d('Fetched histories: $histories');
      return histories;
    } catch (e) {
      logger.e('Error in getHistoryByUserId: $e');
      rethrow;
    }
  }

  // Create a new history record
  Future<void> createHistory(History history) async {
    try {
      await _firestore.collection('histories').add(history.toJson());
      logger.i('History created successfully');
    } catch (e) {
      logger.e('Error in createHistory: $e');
      rethrow;
    }
  }
}
