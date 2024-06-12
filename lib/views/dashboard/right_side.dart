import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/views/engines/engine.dart';
import 'package:flutter_mekanix_app/views/home/home.dart';
import 'package:flutter_mekanix_app/views/profile.dart';
import 'package:flutter_mekanix_app/views/task/task.dart';

class RightSideWidget extends StatelessWidget {
  const RightSideWidget({
    super.key,
    required this.pageController,
    required this.sideMenu,
    required this.tabController,
  });

  final PageController pageController;
  final SideMenuController sideMenu;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const HomeScreen(),
          TaskScreen(sideMenu: sideMenu),
          EnginesScreen(sideMenu: sideMenu),
          Container(),
          ProfileSection(sideMenu: sideMenu),
        ],
      ),
    );
  }
}
