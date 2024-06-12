import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PageController pageController = PageController();
  late TabController tabController;

//------------------------------------------
  var isLoading = true.obs;
  var templateCount = 0.obs;
  var formCount = 0.obs;
  var engineCount = 0.obs;
  var data = <String, dynamic>{}.obs;

  final SideMenuController sideMenu = Get.put(SideMenuController());
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    sideMenu.addListener((index) {
      tabController.animateTo(index,
          duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
      currentPage.value = sideMenu.currentPage;
      debugPrint('CurrentPage: ${currentPage.value}');
      // fetchUserAnalyticsData();
    });
    super.onInit();
  }

// void fetchUserAnalyticsData() async {
//   try {
//     isLoading(true);
//     var result = await DashboardService().fetchData();
//     data.value = result;
//     templateCount.value = result['templates_count'];
//     formCount.value = result['forms_count'];
//     engineCount.value = result['engines_count'];
//   } finally {
//     isLoading(false);
//   }
// }
}
