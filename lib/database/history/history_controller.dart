import 'package:flutter/material.dart';
import 'package:player/database/history/history_class.dart';
import 'package:player/database/history/history_service.dart';

class HistoryController extends ChangeNotifier {
  final HistoryService _historyService = HistoryService();
  List<History> _histories = [];

  List<History> get histories => _histories;

  Future<void> getHistoryByUserId(String userId) async {
    try {
      _histories = await _historyService.getHistoryByUserId(userId);
      notifyListeners();
    } catch (e) {
      print('Error fetching history for user: $e');
      // You might want to handle the error more gracefully here
    }
  }

  Future<void> createHistory(History history) async {
    try {
      await _historyService.createHistory(history);
      notifyListeners(); // Notify listeners after creating history
    } catch (e) {
      print('Error creating history: $e');
      // You might want to handle the error more gracefully here
    }
  }
}
