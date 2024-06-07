import 'dart:typed_data';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/custom_task_controller.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_button.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';
import 'package:flutter_mekanix_app/helpers/reusable_textfield.dart';
import 'package:flutter_mekanix_app/helpers/validator.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:get/get.dart';

class CustomTaskBody extends StatelessWidget {
  final CustomTaskController _customTaskController = Get.find();
  final TextEditingController _hintTextController = TextEditingController();
  final TextEditingController _radioController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CustomTaskBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomButton(
            isLoading: false,
            buttonText: 'Submit',
            onTap: () {
              _customTaskController.sending();
            },
          ),
        ),
        body: ListView(
          children: [
            Obx(
              () => _customTaskController.formSections.isEmpty
                  ? const Center(
                      heightFactor: 15,
                      child: CustomTextWidget(
                          text: 'No Items Added, Tap on + icon to add items.'),
                    )
                  : ReUsableContainer(
                      child: Column(
                        children: [
                          for (var section
                              in _customTaskController.formSections)
                            ReUsableContainer(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    CustomTextWidget(text: section.heading)
                                  ],
                                ))
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void showAddSectionPopup(BuildContext context) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: ReUsableTextField(
                    hintText: 'Enter Section Name',
                    controller: _hintTextController,
                    validator: (value) => AppValidator.validateEmptyText(
                      fieldName: 'Section Name',
                      value: value,
                    ),
                  ),
                ),
                CustomButton(
                  usePrimaryColor: true,
                  buttonText: 'Add Textfield',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      MyFormSection newSection = MyFormSection(
                        heading: _hintTextController.text,
                        elements: [],
                      );
                      _customTaskController.addFormSection(newSection);
                      debugPrint(
                          'FormSectionsLength: ${_customTaskController.formSections.length}');
                      Get.back();
                      _hintTextController.clear();
                    }
                  },
                  isLoading: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showAddElementPopup(BuildContext context) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAddTextFieldButton(context),
            _buildAddTextFieldButton(context, isTextArea: true),
            _buildAddRadioButtonButton(context),
            _buildAddCheckboxButton(context),
            _buildAddAttachmentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTextFieldButton(BuildContext context,
      {bool isTextArea = false}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: isTextArea ? 'Add Textarea' : 'Add Textfield',
      onTap: () {
        Get.back();
        _showTextFieldPopup(context, isTextArea: isTextArea);
      },
      isLoading: false,
    );
  }

  Widget _buildAddRadioButtonButton(BuildContext context) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: 'Add Radio Button',
      onTap: () {
        Get.back();
        _showRadioButtonPopup(context);
      },
      isLoading: false,
    );
  }

  Widget _buildAddCheckboxButton(BuildContext context) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: 'Add Checkbox',
      onTap: () {
        Get.back();
        _showRadioButtonPopup(context, isCheckbox: true);
      },
      isLoading: false,
    );
  }

  Widget _buildAddAttachmentButton(BuildContext context) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: 'Add Attachment',
      onTap: () {
        Get.back();
        _showAttachmentPopup(context);
      },
      isLoading: false,
    );
  }

  void _showTextFieldPopup(BuildContext context, {bool isTextArea = false}) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Column(
        children: [
          Form(
            key: _formKey,
            child: ReUsableTextField(
              hintText: 'Enter Textfield Name',
              controller: _hintTextController,
              validator: (value) => AppValidator.validateEmptyText(
                fieldName: 'Textfield Name',
                value: value,
              ),
            ),
          ),
          CustomButton(
            usePrimaryColor: true,
            buttonText: 'Add Textfield',
            onTap: () {
              if (_formKey.currentState!.validate()) {
                MyCustomItemModel myCustomTaskModel = MyCustomItemModel(
                  label: _hintTextController.text,
                  type: isTextArea
                      ? MyCustomItemType.textArea
                      : MyCustomItemType.textfield,
                  controller: TextEditingController(),
                );
                _customTaskController.addFormElement(myCustomTaskModel);
                Get.back();
                _hintTextController.clear();
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }

  void _showAttachmentPopup(BuildContext context) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Column(
        children: [
          Form(
            key: _formKey,
            child: ReUsableTextField(
              hintText: 'Enter Heading',
              controller: _hintTextController,
              validator: (value) => AppValidator.validateEmptyText(
                fieldName: 'Heading',
                value: value,
              ),
            ),
          ),
          CustomButton(
            usePrimaryColor: true,
            buttonText: 'Add Attachment',
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _customTaskController.addFormElement(
                  MyCustomItemModel(
                    label: _hintTextController.text,
                    type: MyCustomItemType.attachment,
                    controller: Uint8List(0),
                  ),
                );
                Get.back();
                _hintTextController.clear();
              }
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }

  void _showRadioButtonPopup(BuildContext context, {bool isCheckbox = false}) {
    var options = <String>[].obs;
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Obx(
        () => Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ReUsableTextField(
                    hintText: 'Enter Heading',
                    controller: _hintTextController,
                    validator: (value) => AppValidator.validateEmptyText(
                      fieldName: 'Heading',
                      value: value,
                    ),
                  ),
                  ReUsableTextField(
                    hintText: 'Enter Option',
                    controller: _radioController,
                  ),
                  Wrap(
                    children: [
                      for (var option in options)
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Chip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            backgroundColor: AppColors.blueTextColor,
                            deleteIconColor: Colors.red,
                            deleteIcon: const Icon(Icons.clear, size: 20),
                            padding: const EdgeInsets.all(8.0),
                            onDeleted: () {
                              options.remove(option);
                            },
                            label: CustomTextWidget(
                                text: option, textColor: Colors.white70),
                          ),
                        ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (_radioController.text.isEmpty) return;
                      options.add(_radioController.text.trim());
                      _radioController.clear();
                    },
                    child: const CustomTextWidget(
                      text: 'Add Option',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              usePrimaryColor: true,
              buttonText: isCheckbox ? 'Add Checkbox' : 'Add Radio Button',
              onTap: () {
                if (_formKey.currentState!.validate() && options.isNotEmpty) {
                  _customTaskController.addFormElement(
                    MyCustomItemModel(
                      label: _hintTextController.text,
                      type: isCheckbox
                          ? MyCustomItemType.checkbox
                          : MyCustomItemType.radioButton,
                      options: options,
                      controller:
                          isCheckbox ? RxList<String>([]) : RxString(''),
                    ),
                  );
                  Get.back();
                  _hintTextController.clear();
                }
              },
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}

void showCustomPopup(
    {required BuildContext context,
    SideMenuController? sideMenu,
    required double? width,
    required Widget widget}) {
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
                    width: width,
                    // height: context.height * 0.3,
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: context.height * 0.05),

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
                    child: widget,
                  ))));
    },
  );
}
