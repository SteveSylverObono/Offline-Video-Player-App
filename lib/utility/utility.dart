import 'package:flutter/material.dart';

/*
const host = 'https://aicsnetwork-2.onrender.com/api';
const socketio = "https://aicsnetwork-2.onrender.com";
*/

const host = 'http://192.168.38.137:5000/api';

/*const host = 'http://13.53.197.77/api';
const socketio = "http://13.53.197.77/";*/
//'https://aicsnetwork-2.onrender.com'
class CustomSnackBar {
  BuildContext context;

  CustomSnackBar({required this.context});

  void showSnackbar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message!)),
    );
  }
}

class CustomRecorder {

}

class TodoItem {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final bool isLocked;

  TodoItem({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.isLocked,
  });
}
