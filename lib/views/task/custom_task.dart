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
import 'package:flutter_mekanix_app/views/task/widgets/checkbox.dart';
import 'package:flutter_mekanix_app/views/task/widgets/heading.dart';
import 'package:flutter_mekanix_app/views/task/widgets/heading_and_textfield.dart';
import 'package:flutter_mekanix_app/views/task/widgets/radio_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomTaskScreen extends StatefulWidget {
  final bool isTemplateTask;
  final String reportName;
  final MyCustomTask? task;
  final CustomTaskController controller;

  const CustomTaskScreen(
      {super.key,
      required this.reportName,
      this.task,
      required this.isTemplateTask,
      required this.controller});

  @override
  State<CustomTaskScreen> createState() => _CustomTaskScreenState();
}

class _CustomTaskScreenState extends State<CustomTaskScreen> {
  late Rx<MyCustomTask> _task;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _hintTextController = TextEditingController();
  final _radioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _task = Rx<MyCustomTask>(widget.task ??
        MyCustomTask(
          name: widget.reportName,
          formSections: <MyFormSection>[],
          isTemplate: widget.controller.isTemplate.value,
          isForm: widget.controller.isForm.value,
          // files: <Uint8List>[],
        ));
    super.initState();
  }

  void _updateTask() {
    _task.update((task) {
      task?.isTemplate = widget.controller.isTemplate.value;
      task?.isForm = widget.controller.isForm.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/home-bg.png', fit: BoxFit.fill),
          Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 80.0, right: 40),
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.primaryColor,
                mini: true,
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_upward_rounded),
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  pinned: true,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.red,
                  forceMaterialTransparency: true,
                  expandedHeight: context.height * 0.2,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: _buildHeader(context),
                  ),
                ),
              ],
              body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Obx(
                  () => _task.value.formSections.isEmpty
                      ? const Align(
                          alignment: Alignment.center,
                          child: CustomTextWidget(
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            fontSize: 12.0,
                            text: 'No Items Added, Tap on + icon to add items.',
                          ),
                        )
                      : _buildFormSectionsList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReUsableContainer(
          color: AppColors.primaryColor,
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
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                CustomTextWidget(
                  text: widget.reportName,
                  fontSize: 20.0,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                ),
                IconButton(
                  onPressed: () => showAddSectionPopup(context),
                  icon: const Icon(FontAwesomeIcons.circlePlus),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSectionsList() {
    return ReUsableContainer(
      showBackgroundShadow: false,
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _task.value.formSections.length,
                itemBuilder: (context, index) {
                  final section = _task.value.formSections[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReUsableContainer(
                      color: Colors.grey.shade300,
                      showBackgroundShadow: false,
                      child: Column(
                        children: [
                          ContainerHeading(
                            heading: section.heading,
                            onPressed: () => showAddElementPopup(context,
                                sectionIndex: index),
                            onDelete: () {
                              _task.value.formSections.removeAt(index);
                              _task.refresh();
                              // widget.controller.removeFormSection(
                              //     formSection: section, index: index)
                            },
                          ),
                          _buildSectionElements(index),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: !widget.isTemplateTask,
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.blueTextColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const CustomTextWidget(
                      text: 'Save as template for future use',
                      fontSize: 12.0,
                    ),
                    value: widget.controller.isTemplate.value,
                    onChanged: (value) {
                      widget.controller.isTemplate.value = value!;
                    },
                  ),
                ),
                Row(
                  children: [
                    Visibility(
                      visible: !widget.isTemplateTask,
                      child: Flexible(
                        child: CustomButton(
                          usePrimaryColor: true,
                          isLoading: false,
                          buttonText: 'Save as template only',
                          onTap: () {
                            widget.controller.isTemplate.value = true;
                            widget.controller.isForm.value = false;
                            _updateTask();
                            widget.controller.templates.add(_task.value);
                            widget.controller.onSaveAsTemplate(
                              _task.value,
                              // _task.value.files,
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: CustomButton(
                        isLoading: false,
                        buttonText: widget.isTemplateTask ? 'Save' : 'Submit',
                        onTap: () {
                          if (widget.isTemplateTask) {
                            print('Save Template');
                          } else {
                            if (widget.controller.isTemplate.value) {
                              widget.controller.isTemplate.value = true;
                              widget.controller.isForm.value = true;
                              _updateTask();
                              widget.controller.templates.add(_task.value);
                              widget.controller.submittedTasks.add(_task.value);
                            } else {
                              widget.controller.isTemplate.value = false;
                              widget.controller.isForm.value = true;
                              _updateTask();
                              widget.controller.submittedTasks.add(_task.value);
                            }
                            // Get.back();
                            widget.controller.onSubmitTask(
                              _task.value,
                              // _task.value.files,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionElements(int sectionIndex) {
    return Obx(
      () => Column(
        children:
            _task.value.formSections[sectionIndex].elements.map((element) {
          switch (element.type) {
            case MyCustomItemType.textfield:
              return HeadingAndTextfield(
                title: element.label ?? '',
                controller: element.controller,
                showDeleteIcon: true,
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.textarea:
              return HeadingAndTextfield(
                title: element.label ?? '',
                controller: element.controller,
                maxLines: 5,
                showDeleteIcon: true,
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.radiobutton:
              return CustomRadioButton(
                options: element.options ?? [],
                selectedOption: element.controller,
                heading: element.label ?? '',
                showDeleteIcon: true,
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.checkbox:
              return CustomCheckboxWidget(
                options: element.options ?? [],
                heading: element.label ?? '',
                selectedValues: element.controller,
                showDeleteIcon: true,
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.attachment:
              RxString fileName = ''.obs;
              return Obx(
                () => HeadingAndTextfield(
                  title: element.label ?? '',
                  hintText: fileName.value == ''
                      ? 'No file selected'
                      : fileName.value,
                  readOnly: true,
                  onTap: () async {
                    XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );

                    if (image != null) {
                      fileName.value = image.name;
                      // Check file extension
                      String fileExtension =
                          image.name.split('.').last.toLowerCase();
                      if (fileExtension == 'png' ||
                          fileExtension == 'jpeg' ||
                          fileExtension == 'jpg') {
                        // Uint8List imageBytes = await image.readAsBytes();
                        // int i = _task.value.files.length;
                        // _task.value.files.insert(i, imageBytes);
                        // print('File added: ${image.path}');
                      } else {
                        Get.snackbar(
                            'Error.', 'Please select a PNG or JPEG file.');
                      }
                    }
                  },
                  showDeleteIcon: true,
                  onDelete: () {
                    _task.value.formSections[sectionIndex].elements
                        .remove(element);
                    _task.refresh();
                  },
                ),
              );
            default:
              return Container();
          }
        }).toList(),
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
            Form(
              key: _formKey,
              child: ReUsableTextField(
                hintText: 'Enter Section Name',
                controller: _hintTextController,
                validator: (value) => AppValidator.validateEmptyText(
                    fieldName: 'Section Name', value: value),
              ),
            ),
            CustomButton(
              usePrimaryColor: true,
              buttonText: 'Add Section',
              onTap: () {
                MyFormSection newSection = MyFormSection(
                  heading: _hintTextController.text,
                  elements: [],
                );
                _task.value.formSections.add(newSection);
                _hintTextController.clear();
                _task.refresh();
                Get.back();
              },
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }

  void showAddElementPopup(BuildContext context, {required int sectionIndex}) {
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAddTextFieldButton(context, sectionIndex: sectionIndex),
            _buildAddTextFieldButton(context,
                isTextArea: true, sectionIndex: sectionIndex),
            _buildAddCheckboxAndRadioButton(context,
                sectionIndex: sectionIndex, isCheckbox: false),
            _buildAddCheckboxAndRadioButton(context,
                sectionIndex: sectionIndex, isCheckbox: true),
            _buildAddAttachmentButton(context, sectionIndex: sectionIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTextFieldButton(BuildContext context,
      {bool isTextArea = false, required int sectionIndex}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: isTextArea ? 'Add Textarea' : 'Add Textfield',
      onTap: () {
        Get.back();
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
                      fieldName: 'Textfield Name', value: value),
                ),
              ),
              CustomButton(
                usePrimaryColor: true,
                buttonText: 'Add Textfield',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    MyCustomItemModel myCustomItemModel = MyCustomItemModel(
                      label: _hintTextController.text,
                      type: isTextArea
                          ? MyCustomItemType.textarea
                          : MyCustomItemType.textfield,
                      controller: TextEditingController(),
                    );
                    _task.value.formSections[sectionIndex].elements
                        .add(myCustomItemModel);
                    _task.refresh();
                    Get.back();
                    _hintTextController.clear();
                  }
                },
                isLoading: false,
              ),
            ],
          ),
        );
      },
      isLoading: false,
    );
  }

  Widget _buildAddCheckboxAndRadioButton(BuildContext context,
      {required bool isCheckbox, required int sectionIndex}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: isCheckbox ? 'Add Checkbox' : 'Add Radio Button',
      onTap: () {
        Get.back();
        _showRadioButtonPopup(context,
            isCheckbox: isCheckbox, sectionIndex: sectionIndex);
      },
      isLoading: false,
    );
  }

  Widget _buildAddAttachmentButton(BuildContext context,
      {required int sectionIndex}) {
    return CustomButton(
      usePrimaryColor: true,
      buttonText: 'Add Attachment',
      onTap: () {
        Get.back();
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
                      fieldName: 'Heading', value: value),
                ),
              ),
              CustomButton(
                usePrimaryColor: true,
                buttonText: 'Add Attachment',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    MyCustomItemModel myCustomItemModel = MyCustomItemModel(
                      label: _hintTextController.text,
                      type: MyCustomItemType.attachment,
                      controller: Uint8List(0),
                    );
                    _task.value.formSections[sectionIndex].elements
                        .add(myCustomItemModel);
                    _task.refresh();
                    Get.back();
                    _hintTextController.clear();
                  }
                },
                isLoading: false,
              ),
            ],
          ),
        );
      },
      isLoading: false,
    );
  }

  void _showRadioButtonPopup(BuildContext context,
      {bool isCheckbox = false, required int sectionIndex}) {
    var options = <String>[].obs;
    showCustomPopup(
      context: context,
      width: context.width * 0.3,
      widget: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                ReUsableTextField(
                  hintText: 'Enter Heading',
                  controller: _hintTextController,
                  validator: (value) => AppValidator.validateEmptyText(
                      fieldName: 'Heading', value: value),
                ),
                ReUsableTextField(
                  hintText: 'Enter Option',
                  controller: _radioController,
                ),
                Obx(
                  () => Wrap(
                    children: options
                        .map(
                          (option) => Padding(
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
                                _task.refresh();
                              },
                              label: CustomTextWidget(
                                  text: option, textColor: Colors.white70),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_radioController.text.isNotEmpty) {
                      options.add(_radioController.text.trim());
                      _radioController.clear();
                    }
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
                MyCustomItemModel myCustomItemModel = MyCustomItemModel(
                  label: _hintTextController.text,
                  type: isCheckbox
                      ? MyCustomItemType.checkbox
                      : MyCustomItemType.radiobutton,
                  options: options,
                  controller: isCheckbox ? RxList<String>([]) : RxString(''),
                );
                _task.value.formSections[sectionIndex].elements
                    .add(myCustomItemModel);
                _task.refresh();
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
