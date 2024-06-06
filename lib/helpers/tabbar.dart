import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:get/get.dart';

class CustomTabBar extends StatelessWidget {
  final String? title1;
  final String? title2;
  final String? title3;
  final void Function(int)? onTap;

  const CustomTabBar({super.key, this.title1, this.title2, this.title3, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.black45)),
      child: TabBar(
        onTap: onTap,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: AppColors.secondaryColor,
        ),
        labelStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'poppins'),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        tabs: [
          if (title3 != null) ...[
            Tab(text: title1),
            Tab(text: title2),
            Tab(text: title3),
          ] else ...[
            Tab(text: title1),
            Tab(text: title2),
          ],
        ],

        // tabs: [
        //   Tab(text: title1),
        //   Tab(text: title2),
        //   if (title3 != null) Tab(text: title3),
        // ],
      ),
    );
  }
}
