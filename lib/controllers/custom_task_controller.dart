import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:get/get.dart';

class CustomTaskController extends GetxController {
  final formElements = <MyCustomItemModel>[].obs;
  final formSections = <MyFormSection>[].obs;
  final tasks = <MyCustomTask>[].obs;
  
  // final images = <Uint8List>[].obs;

  // @override
  // void onInit() {
  //   debugPrint('formSections: ${formSections.length}');
  //   debugPrint('FormElements: ${formElements.length}');
  //   super.onInit();
  // }

  void addTask(MyCustomTask e) => tasks.add(e);

  void removeTask(MyCustomTask e) => tasks.remove(e);

  void addFormSection(MyFormSection e) => formSections.add(e);

  void removeFormSection(MyFormSection e) => formSections.remove(e);

  void addFormElement(MyCustomItemModel e) => formElements.add(e);

  void removeFormElement(MyCustomItemModel e) => formElements.remove(e);

  void sending() {
    var list = formElements.map((e) => e.toMap()).toList();
    debugPrint('OnSubmit: ${jsonEncode(list)}');
  }
}
