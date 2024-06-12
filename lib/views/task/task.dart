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
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  RxInt currentPage = 0.obs;

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
                      expandedHeight: context.height * 0.13,
                      pinned: false,
                      floating: true,
                      primary: false,
                      backgroundColor: Colors.transparent,
                      excludeHeaderSemantics: false,
                      forceMaterialTransparency: false,
                      flexibleSpace: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Obx(
                            () => TopSection(
                              sideMenuController: widget.sideMenu,
                              controller: controller,
                              reportNameController: reportNameController,
                              universalController: widget.universalController,
                              currentPage: currentPage.value,
                            ),
                          )
                        ],
                      ),
                    )
                  ];
                },
                body: Column(
                  children: [
                    // ReUsableTextField(
                    //   controller: controller.searchController,
                    //   hintText: 'Search Task',
                    //   suffixIcon: const Icon(Icons.search_sharp),
                    //   onChanged: (value) {
                    //     if (currentPage.value == 0) {
                    //       debugPrint('SearchingSubmittedTasks');
                    //       controller.getAllCustomTasks(searchName: value);
                    //     } else {
                    //       debugPrint('SearchingTemplates');
                    //       controller.getAllCustomTasks(
                    //           searchName: value, isTemplate: true);
                    //     }
                    //   },
                    // ),
                    const CustomTabBar(
                      // onTap: (val) {
                      //   currentPage.value = val;
                      // },
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
  final int currentPage;

  const TopSection({
    super.key,
    required this.sideMenuController,
    required this.controller,
    required this.reportNameController,
    required this.universalController,
    required this.currentPage,
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
                            universalController: universalController,
                            currentPage: currentPage);
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

  Future<void> _refreshTasks() {
    return isTemplate
        ? controller.getAllCustomTasks(page: 1, isTemplate: true)
        : controller.getAllCustomTasks(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isTasksAreLoading.value) {
        return const Center(
          child: SpinKitRing(
            lineWidth: 2.0,
            color: Colors.black87,
            size: 30.0,
          ),
        );
      } else if (tasks.isEmpty) {
        return Center(
          heightFactor: 10.0,
          child: CustomTextWidget(
            text: isTemplate
                ? 'No Templates Available'
                : 'No Submitted Tasks Available',
          ),
        );
      } else {
        return RefreshIndicator(
          onRefresh: _refreshTasks,
          color: AppColors.primaryColor,
          backgroundColor: AppColors.secondaryColor,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
                child: ReUsableContainer(
                  child: ListTile(
                    onTap: () {
                      Get.to(
                        () => CustomTaskScreen(
                          reportName: task.name,
                          task: task,
                          isTemplate: task.isTemplate,
                        ),
                      );
                    },
                    trailing: InkWell(
                      onTap: () {
                        _showDeletePopup(
                            context: context,
                            controller: controller,
                            id: task.id ?? '');
                      },
                      child: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
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
    });
  }
}

class CustomPopup {
  static void show({
    required BuildContext context,
    required TextEditingController reportNameController,
    required CustomTaskController controller,
    required UniversalController universalController,
    required int currentPage,
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
            title: 'Enter ${currentPage == 0 ? 'Report' : 'Template'} Name',
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
                      reportName: reportNameController.text.trim(),
                      isTemplate: currentPage == 0 ? false : true,
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

void _showDeletePopup(
    {required BuildContext context,
    required CustomTaskController controller,
    required String id}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: AlertDialog(
                  scrollable: true,
                  backgroundColor: Colors.transparent,
                  content: Container(
                    width: context.width * 0.5,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: context.height * 0.02),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(255, 220, 105, 0.4),
                          Color.fromRGBO(86, 127, 255, 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            spreadRadius: 5.0),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomTextWidget(
                            text:
                                'Are you sure to delete the Task? This action cannot be undone.',
                            fontSize: 14.0,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400),
                        const SizedBox(height: 12.0),
                        Obx(
                          () => InkWell(
                              onTap: () {
                                controller.deleteCustomTask(taskId: id);
                              },
                              child: ReUsableContainer(
                                verticalPadding: context.height * 0.01,
                                height: 50,
                                color: Colors.red,
                                child: Center(
                                    child: controller.isLoading.value
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SpinKitRing(
                                              lineWidth: 2.0,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const CustomTextWidget(
                                            text: 'Delete',
                                            fontSize: 12,
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                          )),
                              )),
                        ),
                        CustomButton(
                          isLoading: false,
                          usePrimaryColor: false,
                          buttonText: 'Cancel',
                          fontSize: 12.0,
                          onTap: () {
                            Get.back();
                          },
                        )
                      ],
                    ),
                  ))));
    },
  );
}
