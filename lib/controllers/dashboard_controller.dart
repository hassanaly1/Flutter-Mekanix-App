import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PageController pageController = PageController();
  late TabController tabController;

  // var isLoading = false.obs;
  // var isFormsAreLoading = false.obs;
  // var isEnginesAreLoading = false.obs;
  // var isTemplatesAreLoading = false.obs;
  // var templateCount = 0.obs;
  // var formCount = 0.obs;
  // var engineCount = 0.obs;
  // var templateAnalytics = <Analytic>[].obs;
  // var formAnalytics = <Analytic>[].obs;
  // var engineAnalytics = <Analytic>[].obs;

  final SideMenuController sideMenu = Get.put(SideMenuController());
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    // fetchUserAnalyticsData();
    sideMenu.addListener((index) {
      tabController.animateTo(index,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
      currentPage.value = sideMenu.currentPage;
      debugPrint('CurrentPage: ${currentPage.value}');
    });
    super.onInit();
  }
}
