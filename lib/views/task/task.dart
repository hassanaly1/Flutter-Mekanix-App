import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/custom_task_controller.dart';
import 'package:flutter_mekanix_app/controllers/universal_controller.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_button.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/dropdown.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';
import 'package:flutter_mekanix_app/helpers/tabbar.dart';
import 'package:flutter_mekanix_app/helpers/toast.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/services/engine_service.dart';
import 'package:flutter_mekanix_app/views/task/custom_task.dart';
import 'package:flutter_mekanix_app/views/task/scan_qrcode.dart';
import 'package:flutter_mekanix_app/views/task/widgets/heading_and_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TaskScreen extends StatefulWidget {
  final SideMenuController sideMenu;

  TaskScreen({super.key, required this.sideMenu});

  final UniversalController universalController = Get.find();

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late CustomTaskController controller;
  TextEditingController reportNameController = TextEditingController();

  @override
  void initState() {
    controller = Get.put(CustomTaskController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          widget.sideMenu.changePage(0);
        },
        child: DefaultTabController(
          length: 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.0),
                topRight: Radius.circular(32.0),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
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
                          TopSection(
                            sideMenuController: widget.sideMenu,
                            controller: controller,
                            reportNameController: reportNameController,
                            universalController: widget.universalController,
                          )
                        ],
                      ),
                    )
                  ];
                },
                body: Column(
                  children: [
                    const CustomTabBar(
                      title1: 'Submitted Tasks',
                      title2: 'Templates',
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          TaskListView(
                            isTemplate: false,
                            controller: controller,
                            tasks: controller.submittedTasks,
                          ),
                          TaskListView(
                            isTemplate: true,
                            controller: controller,
                            tasks: controller.templates,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  final CustomTaskController controller;
  final SideMenuController sideMenuController;
  final TextEditingController reportNameController;
  final UniversalController universalController;

  const TopSection({
    super.key,
    required this.sideMenuController,
    required this.controller,
    required this.reportNameController,
    required this.universalController,
  });

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const IconButton(
                      onPressed: null,
                      icon: Icon(FontAwesomeIcons.circlePlus,
                          color: Colors.transparent),
                    ),
                    const CustomTextWidget(
                      text: 'Custom Task',
                      fontSize: 16.0,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                    ),
                    IconButton(
                      onPressed: () {
                        CustomPopup.show(
                            context: context,
                            reportNameController: reportNameController,
                            controller: controller,
                            universalController: universalController);
                      },
                      icon: const Icon(FontAwesomeIcons.circlePlus),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  final bool isTemplate;
  final List<MyCustomTask> tasks;
  final CustomTaskController controller;

  const TaskListView({
    super.key,
    required this.tasks,
    required this.isTemplate,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => tasks.isEmpty
          ? Center(
              heightFactor: 10.0,
              child: CustomTextWidget(
                text: isTemplate
                    ? 'No Templates Available'
                    : 'No Submitted Tasks Available',
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: context.width * 0.04),
                  child: ReUsableContainer(
                    child: ListTile(
                      onTap: () {
                        Get.to(
                          () => CustomTaskScreen(
                            controller: controller,
                            reportName: task.name,
                            task: task,
                            isTemplateTask: task.isTemplate,
                          ),
                        );
                      },
                      leading: CustomTextWidget(
                        text: '${index + 1}'.toString(),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      title: CustomTextWidget(
                        text: task.name,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      titleAlignment: ListTileTitleAlignment.center,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class CustomPopup {
  static void show({
    required BuildContext context,
    required TextEditingController reportNameController,
    required CustomTaskController controller,
    required UniversalController universalController,
  }) {
    showCustomPopup(
      context: context,
      width: context.isLandscape ? context.width * 0.3 : context.width * 0.5,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextWidget(
            text: 'New Task',
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 24.0),
          HeadingAndTextfield(
            title: 'Enter Report Name',
            fontSize: 12.0,
            controller: reportNameController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextWidget(
                text: 'Engine Brand',
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                maxLines: 2,
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => const ScanQrCodeScreen(),
                      transition: Transition.rightToLeft);
                },
                icon: const Icon(Icons.qr_code),
              ),
            ],
          ),
          Obx(
            () => InkWell(
              onTap: () {
                universalController.engines.isEmpty
                    ? ToastMessage.showToastMessage(
                        message:
                            'Please Add Engines first from the Engine section.',
                        backgroundColor: Colors.red)
                    : null;
              },
              child: CustomDropdown(
                items: universalController.engines,
                hintText: controller.engineBrandName.value != ''
                    ? controller.engineBrandName.value
                    : 'Select Engine Brand',
                onChanged: (value) async {
                  try {
                    final result = await EngineService()
                        .getEngineData(engineName: value?.name ?? '');

                    if (result['success']) {
                      final engineData = result['data'];
                      final engineId = engineData['_id'];
                      final engineName = engineData['name'];

                      controller.engineBrandName.value = engineName ?? '';
                      controller.engineBrandId.value = engineId;
                      debugPrint('EngineId: ${controller.engineBrandId.value}');
                      debugPrint(
                          'EngineName: ${controller.engineBrandName.value}');
                    } else {
                      final errorMessage = result['message'];
                      debugPrint('Failed to fetch engine data');
                      debugPrint('ErrorData: ${result['data']}');
                      debugPrint('ErrorMessage: $errorMessage');

                      ToastMessage.showToastMessage(
                          message: errorMessage,
                          backgroundColor: AppColors.blueTextColor);
                    }
                  } catch (e) {
                    debugPrint('An error occurred: $e');
                    ToastMessage.showToastMessage(
                        message: 'An error occurred, please try again',
                        backgroundColor: AppColors.blueTextColor);
                  }
                },
              ),
            ),
          ),
          CustomButton(
            buttonText: 'Create',
            onTap: () {
              if (reportNameController.text.isNotEmpty) {
                if (controller.engineBrandName.value.isNotEmpty &&
                    controller.engineBrandId.value.isNotEmpty) {
                  Get.back();
                  Get.to(
                    () => CustomTaskScreen(
                      controller: controller,
                      reportName: reportNameController.text.trim(),
                      isTemplateTask: false,
                    ),
                  );
                } else {
                  ToastMessage.showToastMessage(
                      message: 'Please Select Engine from the Dropdown.',
                      backgroundColor: AppColors.blueTextColor);
                }
              } else {
                ToastMessage.showToastMessage(
                    message: 'Please Enter Report Name.',
                    backgroundColor: AppColors.blueTextColor);
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }
}
