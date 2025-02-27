import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:player/screen/admin/admindasboard.dart';
import 'package:player/screen/admin/managenotification.dart';
import 'package:player/screen/admin/usersdasboard.dart';
import 'package:flutter/material.dart';

import '../entry_point.dart';
import '../screen/auth/login_screen.dart';
import '../screen/auth/signup_screen.dart';
import '../screen/dashboard.dart';
import '../screen/onboard/onbording_screen.dart';
import '../screen/profile/edit_screen.dart';
import '../screen/video/video_list_screen.dart';
import '../screen/video/video_player_screen.dart';
import '../splash_screen.dart';
part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashScreenRoute.page, initial: true),
        AutoRoute(page: LoginScreenRoute.page, initial: false),
        AutoRoute(page: SignUpScreenRoute.page, initial: false),
        AutoRoute(page: EntryPointRoute.page, initial: false),
        AutoRoute(page: OnboardingScreenRoute.page, initial: false),
        AutoRoute(page: DashBoardScreenRoute.page, initial: false),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: AdminDasbBoardRoute.page, initial: false),
        AutoRoute(page: ManageNotificationRoute.page),
        AutoRoute(page: UsersDashboardRoute.page),
        AutoRoute(page: VideoListScreenRoute.page),
        AutoRoute(page: VideoPlayerScreenRoute.page),
      ];
}
