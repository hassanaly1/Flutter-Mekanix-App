import 'dart:typed_data';

import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/services/task_service.dart';
import 'package:get/get.dart';

class CustomTaskController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isTemplate = false.obs;
  RxBool isForm = false.obs;
  final submittedTasks = <MyCustomTask>[].obs;
  final templates = <MyCustomTask>[].obs;
  final attachments = <Uint8List>[].obs;
  RxString engineBrandId = ''.obs;
  RxString engineBrandName = ''.obs;

  final TaskService _taskService = TaskService();

  void onSubmitTask(MyCustomTask e) {
    _taskService.addCustomTask(task: e);
  }

  void onSaveAsTemplate(MyCustomTask e) {
    // debugPrint('OnSaveAsTemplate: ${jsonEncode(e.toMap())}');
  }
}

// var list = submittedTasks.map((e) => e.toMap()).toList();
// debugPrint('OnSubmit: ${jsonEncode(list)}');

// void addTask(MyCustomTask e) => tasks.add(e);
//
// void removeTask(MyCustomTask e) => tasks.remove(e);
//
// void addFormSection(
//     {required MyFormSection formSection, required int index}) {
//   tasks[index].formSections.add(formSection);
//   debugPrint(
//       'formSectionsAtTaskAtIndex$index: ${tasks[index].formSections.length}');
// }
//
// void removeFormSection(
//     {required MyFormSection formSection, required int index}) {
//   tasks[index].formSections.remove(formSection);
//   debugPrint(
//       'formSectionsAtTaskAtIndex$index: ${tasks[index].formSections.length}');
// }

// void addFormElement({
//   required MyCustomItemModel item,
//   required int taskIndex,
//   required int sectionIndex,
// }) {
//   tasks[taskIndex].formSections[sectionIndex].elements.add(item);
//   tasks.refresh();
//   debugPrint(
//       'FormElementsAtSectionIndex$sectionIndex: ${tasks[taskIndex].formSections[sectionIndex].elements.length}');
// }
//
// void removeFormElement({
//   required MyCustomItemModel item,
//   required int taskIndex,
//   required int sectionIndex,
// }) {
//   tasks[taskIndex].formSections[sectionIndex].elements.remove(item);
//   tasks.refresh();
//   debugPrint(
//       'FormElementsAtSectionIndex$sectionIndex: ${tasks[taskIndex].formSections[sectionIndex].elements.length}');
// }
