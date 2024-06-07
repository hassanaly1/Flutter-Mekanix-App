import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/custom_task_controller.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/views/task/custom_task_body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomTaskScreen extends StatelessWidget {
  final MyCustomTask task;
  final CustomTaskController controller;
  final SideMenuController sideMenu;
  final String reportName;

  const CustomTaskScreen({
    super.key,
    required this.task,
    required this.sideMenu,
    required this.reportName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/home-bg.png', fit: BoxFit.fill),
        Container(
          decoration: const BoxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: NestedScrollView(
                // controller: controller.scrollController,
                // floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: context.height * 0.15,
                      pinned: false,
                      floating: true,
                      primary: false,
                      backgroundColor: Colors.transparent,
                      excludeHeaderSemantics: false,
                      forceMaterialTransparency: false,
                      flexibleSpace: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          TopSection(reportName: reportName),
                        ],
                      ),
                    ),
                  ];
                },
                body: BottomPageViewSection(sideMenuController: sideMenu)),
            floatingActionButton: FloatingActionButton(
              // onPressed: () => controller.scrollUp(),
              onPressed: () {},
              backgroundColor: AppColors.primaryColor,
              mini: true,
              shape: const CircleBorder(),
              child: const Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ),
      ],
    ));
  }
}

class TopSection extends StatelessWidget {
  final String reportName;

  const TopSection({super.key, required this.reportName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: context.width,
              child: ReUsableContainer(
                color: AppColors.primaryColor,
                width: context.width * 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                            Get.delete<CustomTaskController>();
                          },
                          icon: const Icon(Icons.arrow_back_rounded)),
                      CustomTextWidget(
                        text: reportName,
                        fontSize: 20.0,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                CustomTaskBody().showAddSectionPopup(context),
                            icon: const Icon(FontAwesomeIcons.circlePlus),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.qr_code)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomPageViewSection extends StatelessWidget {
  final SideMenuController sideMenuController;

  const BottomPageViewSection({
    super.key,
    required this.sideMenuController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: CustomTaskBody()),
      ],
    );
  }
}
