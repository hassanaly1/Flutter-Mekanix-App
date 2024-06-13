import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/helpers/toast.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/services/task_service.dart';
import 'package:get/get.dart';

class CustomTaskController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isTasksAreLoading = false.obs;
  RxBool isTemplate = false.obs;
  RxBool isForm = false.obs;
  var submittedTasks = <MyCustomTask>[].obs;
  var templates = <MyCustomTask>[].obs;
  final RxInt currentPage = 1.obs;
  TextEditingController searchController = TextEditingController();

  RxString engineBrandId = ''.obs;
  RxString engineBrandName = ''.obs;

  Future<void> getAllCustomTasks(
      {String? searchName, int? page, bool isTemplate = false}) async {
    debugPrint(
        'Page${page ?? currentPage.value} ${isTemplate ? 'Template' : 'Submitted'} tasks called.');
    try {
      isTasksAreLoading.value = true;
      List<MyCustomTask> fetchedTasks = await TaskService().getAllCustomTasks(
        searchString: searchName ?? '',
        token: storage.read('token'),
        page: page ?? currentPage.value,
        isTemplate: isTemplate,
      );

      debugPrint(
          '${isTemplate ? 'Templates' : 'Submitted Tasks'}: ${fetchedTasks.length}');

      if (isTemplate) {
        templates.assignAll(fetchedTasks);
      } else {
        submittedTasks.assignAll(fetchedTasks);
      }
    } catch (e) {
      debugPrint('Error fetching Tasks: $e');
    } finally {
      isTasksAreLoading.value = false;
    }
  }

  Future<void> deleteCustomTask({taskId}) async {
    isLoading.value = true;
    try {
      bool taskDeleted = await TaskService().deleteTaskById(
        taskId: taskId,
        token: storage.read('token'),
      );

      if (taskDeleted) {
        getAllCustomTasks(page: 1);
        getAllCustomTasks(page: 1, isTemplate: true);
        ToastMessage.showToastMessage(
            message: 'Task Deleted Successfully',
            backgroundColor: Colors.green);
        Get.back();
      } else {
        Get.back();
        ToastMessage.showToastMessage(
            message: 'Failed to delete task, please try again',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.back();
      ToastMessage.showToastMessage(
          message: 'Something went wrong, please try again',
          backgroundColor: Colors.red);
      debugPrint('Error deleting task: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
