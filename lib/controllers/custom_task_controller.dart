import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:get/get.dart';

class CustomTaskController extends GetxController {
  RxBool saveAsTemplate = false.obs;
  final submittedTasks = <MyCustomTask>[].obs;
  final templates = <MyCustomTask>[].obs;

// final images = <Uint8List>[].obs;

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

// void sending() {
//   var list = tasks.map((e) => e.toMap()).toList();
//   debugPrint('OnSubmit: ${jsonEncode(list)}');
// }
}
