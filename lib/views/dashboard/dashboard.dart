import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/dashboard_controller.dart';
import 'package:flutter_mekanix_app/controllers/universal_controller.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/views/dashboard/right_side.dart';
import 'package:flutter_mekanix_app/views/dashboard/side_menu.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final UniversalController universalController =
      Get.put(UniversalController());
  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    debugPrint('DashboardScreenOnInitCalled');
    controller.tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DashboardScreenBuildCalled');
    return SafeArea(
      child: DefaultTabController(
        length: 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/home-bg.png', fit: BoxFit.fill),
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              drawer: !context.isLandscape
                  ? Drawer(
                      child: SideMenuCard(
                      sideMenu: controller.sideMenu,
                      scaffoldKey: _scaffoldKey,
                    ))
                  : null,
              body: Column(
                children: [
                  HomeAppbar(
                    sideMenu: controller.sideMenu,
                    scaffoldKey: _scaffoldKey,
                  ),
                  Expanded(
                    child: Container(
                      decoration: _buildContainerDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (context.isLandscape)
                            SideMenuCard(
                                sideMenu: controller.sideMenu,
                                scaffoldKey: _scaffoldKey),
                          RightSideWidget(
                            pageController: controller.pageController,
                            sideMenu: controller.sideMenu,
                            tabController: controller.tabController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromRGBO(255, 220, 105, 0.4),
          Color.fromRGBO(86, 127, 255, 0.4),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5.0,
          spreadRadius: 5.0,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ],
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
    );
  }
}

class HomeAppbar extends StatelessWidget {
  final SideMenuController sideMenu;
  final GlobalKey<ScaffoldState> scaffoldKey;

  HomeAppbar({super.key, required this.sideMenu, required this.scaffoldKey});

  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * 0.15,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (context.isLandscape)
                    Image.asset(
                      'assets/images/app-logo-white.png',
                      height: context.height * 0.08,
                      fit: BoxFit.cover,
                    )
                  else
                    IconButton(
                      onPressed: () {
                        scaffoldKey.currentState?.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu_open_rounded,
                        size: 30.0,
                        color: Colors.white70,
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: context.isLandscape
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.logout_rounded),
                          )
                        : const CircleAvatar(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
            Obx(() => _buildTitleText()),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Flexible(
      child: CustomTextWidget(
        text: _getTitleText(controller.currentPage.value),
        textColor: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _getTitleText(int currentPage) {
    switch (currentPage) {
      case 0:
        return 'Service reports made easy';
      case 1:
        return 'Task';
      case 2:
        return 'Engines';
      case 4:
        return 'Profile';
      default:
        return '';
    }
  }
}
