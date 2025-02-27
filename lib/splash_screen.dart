import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:player/utility/shareprferences.dart';
import 'package:provider/provider.dart';

import 'package:player/routes/app_router.dart';

import 'database/user_db/user_controller.dart';
@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  CustomSharePreference prefs = CustomSharePreference();
  final log = Logger();

  void checkToken() async {
    try {
      String? token = await prefs.getPreferenceValue("user");

      if (token != null) {
        final userController = context.read<UserController>();
        await userController.initializeCurrentUser();
        log.e(userController.currentUser?.userId);
        log.e('Token exists, navigating to EntryPointRoute');
        AutoRouter.of(context).replace(EntryPointRoute());
      } else {
        //log.e('No token found, navigating to OnboardingScreenRoute');
        AutoRouter.of(context).replace(OnboardingScreenRoute());
      }
    } catch (e) {
      //log.e('Error checking token: $e');
     AutoRouter.of(context).replace(OnboardingScreenRoute());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      checkToken();
    });
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedIcon(
              icon: AnimatedIcons.pause_play,
              progress: _controller,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),
        FadeTransition(
          opacity: _animation,
          child: Text(
            'Aurify',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(height: 10),
        FadeTransition(
          opacity: _animation,
          child: Text(
            'Your Personal Music Universe',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: _buildSplashContent(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@RoutePage(name: 'VideoPlayerScreenRoute')
class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  CustomSharePreference prefs = CustomSharePreference();
  final log = Logger();

  void checkToken() async {
    try {
      String? token = await prefs.getPreferenceValue("user");

      if (token != null) {
        final userController = context.read<UserController>();
        await userController.initializeCurrentUser();
        log.e(userController.currentUser?.userId);
        log.e('Token exists, navigating to EntryPointRoute');
        AutoRouter.of(context).replace(EntryPointRoute());
      } else {
        //log.e('No token found, navigating to OnboardingScreenRoute');
        AutoRouter.of(context).replace(OnboardingScreenRoute());
      }
    } catch (e) {
      //log.e('Error checking token: $e');
     AutoRouter.of(context).replace(OnboardingScreenRoute());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      checkToken();
    });
  }

  Widget _buildVideoPlayerContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotationTransition(
          turns: _animation,
          child: Icon(
            Icons.play_circle_filled,
            size: 100,
            color: Colors.redAccent,
          ),
        ),
        SizedBox(height: 20),
        FadeTransition(
          opacity: _animation,
          child: Text(
            'Stream Now',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 42,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(height: 10),
        FadeTransition(
          opacity: _animation,
          child: Text(
            'Watch your favorite videos',
            style: TextStyle(
              color: Colors.redAccent.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      body: Center(
        child: _buildVideoPlayerContent(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}