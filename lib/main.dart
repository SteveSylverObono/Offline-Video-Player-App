import 'package:player/firebase_options.dart';
import 'package:player/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

import 'database/history/history_controller.dart';
import 'database/notifcation/notification_controller.dart';
import 'database/user_db/user_controller.dart';
final logger =Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize app without waiting for permissions
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserController()),
          ChangeNotifierProvider(create: (_) => HistoryController()),
          ChangeNotifierProvider(create: (_) => NotificationController()),
        ],
        child: AurifyApp(),
      ),
    );

    // Request permissions after app is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissions();
    });
  } catch (e) {
    logger.e('Error during initialization: $e');
  }
}

Future<void> _requestPermissions() async {
  try {
    logger.i('Requesting storage permissions');
    final storageStatus = await Permission.storage.request();
    final manageStorageStatus = await Permission.manageExternalStorage.request();

    // Check if essential permissions are granted
    if (!storageStatus.isGranted || !manageStorageStatus.isGranted) {
      logger.w('Essential permissions not granted');
      
      // If permissions are permanently denied, open app settings
      if (await Permission.storage.isPermanentlyDenied || 
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        logger.i('Permissions permanently denied, opening app settings');
        openAppSettings();
      } else {
        logger.i('Showing permission rationale');
        await _showPermissionRationale();
      }
    }

    logger.i('Requesting other permissions');
    await Permission.audio.request();
    await Permission.mediaLibrary.request();
    await Permission.notification.request();
    await Permission.location.request();
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
  } catch (e) {
    logger.e('Error requesting permissions: $e');
  }
}

Future<void> _showPermissionRationale() async {
  logger.i('Showing permission rationale to user');
}

class AurifyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
    );
  }
}
