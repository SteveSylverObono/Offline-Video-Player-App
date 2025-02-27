import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/routes/app_router.dart';

import 'package:player/screen/profile/components/profile_menu_item_list_tile.dart';

import '../../components/list_tile/divider_list_tile.dart';
import '../../constants.dart';

@RoutePage(name: 'AdminDasbBoardRoute')
class Admindasboard extends StatelessWidget {
  const Admindasboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: ListView(
        children: [
          ProfileMenuListTile(
            text: "Notification",
            svgSrc: "assets/icons/Wallet.svg",
            press: () {
              AutoRouter.of(context).push(ManageNotificationRoute());
            },
          ),
          ProfileMenuListTile(
            text: "Mutuelle",
            svgSrc: "assets/icons/Accessories.svg",
            press: () {
              // AutoRouter.of(context).push(ManageMutuelleRoute());
            },
          ),
          ProfileMenuListTile(
            text: "Users",
            svgSrc: "assets/icons/Accessories.svg",
            press: () {
              AutoRouter.of(context).push(UsersDashboardRoute());
            },
          ),
          const SizedBox(height: defaultPadding),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Notification",
            trilingText: "Off",
            press: () {
              //Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Preferences",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              //Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
        ],
      ),
    );
  }
}
