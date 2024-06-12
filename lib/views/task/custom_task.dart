import 'dart:io';
import 'dart:typed_data';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_button.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';
import 'package:flutter_mekanix_app/helpers/reusable_textfield.dart';
import 'package:flutter_mekanix_app/helpers/validator.dart';
import 'package:flutter_mekanix_app/models/custom_task_model.dart';
import 'package:flutter_mekanix_app/services/task_service.dart';
import 'package:flutter_mekanix_app/views/task/widgets/checkbox.dart';
import 'package:flutter_mekanix_app/views/task/widgets/heading.dart';
import 'package:flutter_mekanix_app/views/task/widgets/heading_and_textfield.dart';
import 'package:flutter_mekanix_app/views/task/widgets/radio_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomTaskScreen extends StatefulWidget {
  final bool isTemplate;
  final String reportName;
  final MyCustomTask? task;

  const CustomTaskScreen({
    super.key,
    this.task,
    required this.isTemplate,
    required this.reportName,
  });

  @override
  State<CustomTaskScreen> createState() => _CustomTaskScreenState();
}

class _CustomTaskScreenState extends State<CustomTaskScreen> {
  late Rx<MyCustomTask> _task;
  final _isForm = true.obs, _isTemplate = false.obs;
  final _attachments = <Uint8List>[];
  final _hintTextController = TextEditingController();
  final _radioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _task = Rx<MyCustomTask>(widget.task ??
        MyCustomTask(
          name: widget.reportName,
          formSections: <MyFormSection>[],
          isForm: _isForm.value,
          isTemplate: _isTemplate.value,
        ));
    super.initState();
  }

  // void _updateTask() {
  //   _isTemplate.value = !_isTemplate.value;
  //   _task.value.isTemplate = _isTemplate.value;
  //   // _task.update((task) {
  //   //   task?.isForm = widget.controller.isForm.value;
  //   //   task?.isTemplate = widget.controller.isTemplate.value;
  //   // });
  // }

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
              padding: const EdgeInsets.only(bottom: 40.0),
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
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.red,
                  forceMaterialTransparency: true,
                  expandedHeight: context.height * 0.1,
                  flexibleSpace: Center(
                    child: CustomTextWidget(
                      text: widget.reportName,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      textColor: Colors.white70,
                    ),
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
                  () => Column(
                    children: [
                      _buildHeader(context),
                      _task.value.formSections.isEmpty
                          ? const Align(
                              alignment: Alignment.center,
                              child: CustomTextWidget(
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                fontSize: 12.0,
                                text:
                                    'No Items Added, Tap on + icon to add items.',
                              ),
                            )
                          : Expanded(child: _buildFormSectionsList()),
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
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
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
                            onAdd: () => showAddElementPopup(context,
                                sectionIndex: index),
                            onDelete: () {
                              _task.value.formSections.removeAt(index);
                              _task.refresh();
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: !widget.isTemplate,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.blueTextColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const CustomTextWidget(
                    text: 'Save as template for future use',
                    fontSize: 12.0,
                  ),
                  value: _isTemplate.value,
                  onChanged: (value) {
                    _isTemplate.value = !_isTemplate.value;
                    _task.value.isTemplate = _isTemplate.value;
                  },
                ),
              ),
              CustomButton(
                isLoading: false,
                buttonText: _isTemplate.value ? 'Save as template' : 'Submit',
                onTap: () {
                  print(_task.value.toMap());
                  print(_attachments.length);
                  onSubmitTask(_task.value, _attachments);
                },
              )
            ],
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
                showDeleteIcon: true,
                title: element.label ?? '',
                controller: TextEditingController(text: element.value),
                onChanged: (String? value) => element.value = value ?? '',
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.textarea:
              return HeadingAndTextfield(
                maxLines: 5,
                showDeleteIcon: true,
                title: element.label ?? '',
                controller: TextEditingController(text: element.value),
                onChanged: (String? value) => element.value = value ?? '',
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.radiobutton:
              return CustomRadioButton(
                options: element.options ?? [],
                selectedOption: RxString(element.value ?? ''),
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
                selectedValues:
                    RxList<String>(((element.value ?? []) as List<String>)),
                showDeleteIcon: true,
                onDelete: () {
                  _task.value.formSections[sectionIndex].elements
                      .remove(element);
                  _task.refresh();
                },
              );
            case MyCustomItemType.attachment:
              RxString fileName = ''.obs;
              RxString imagePath = ''.obs;
              return Obx(
                () => HeadingAndTextfield(
                  title: element.label ?? '',
                  hintText: fileName.value == ''
                      ? 'No file selected'
                      : fileName.value,
                  readOnly: true,
                  onTap: () async {
                    int? oldIndex;
                    if (fileName.value != '') {
                      final List<MyCustomElementModel> elements =
                          _task.value.formSections[sectionIndex].elements;
                      oldIndex = elements.indexOf(element);
                    }
                    XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      fileName.value = image.name;
                      imagePath.value = image.path;
                      String fileExtension =
                          image.name.split('.').last.toLowerCase();
                      if (fileExtension == 'png' ||
                          fileExtension == 'jpeg' ||
                          fileExtension == 'jpg') {
                        Uint8List imageBytes = await image.readAsBytes();
                        if (oldIndex != null) {
                          _attachments[oldIndex] = imageBytes;
                        } else {
                          int i = _attachments.length;
                          _attachments.insert(i, imageBytes);
                          element.value = i;
                        }
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
                    fileName.value = '';
                    imagePath.value = '';
                    _task.refresh();
                  },
                  showEyeIcon: fileName.value != '',
                  onEyeTap: () {
                    if (imagePath.value.isNotEmpty) {
                      Get.dialog(
                        Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.file(File(imagePath.value)),
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
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
                    MyCustomElementModel myCustomItemModel =
                        MyCustomElementModel(
                      label: _hintTextController.text,
                      type: isTextArea
                          ? MyCustomItemType.textarea
                          : MyCustomItemType.textfield,
                      value: '',
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
                    MyCustomElementModel myCustomItemModel =
                        MyCustomElementModel(
                      label: _hintTextController.text,
                      type: MyCustomItemType.attachment,
                      value: null,
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
                MyCustomElementModel myCustomItemModel = MyCustomElementModel(
                  label: _hintTextController.text,
                  type: isCheckbox
                      ? MyCustomItemType.checkbox
                      : MyCustomItemType.radiobutton,
                  options: options,
                  value: isCheckbox ? <String>[] : '',
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

  onSubmitTask(MyCustomTask e, List<Uint8List> attachments) async {
    final urls = <String>[];
    TaskResponse response =
        await TaskService().addCustomTaskFiles(attachments: attachments);
    if (response.isSuccess) {
      urls.assignAll(response.data);
      print(urls);
      for (MyFormSection section in e.formSections) {
        for (MyCustomElementModel element in section.elements) {
          if (element.type == MyCustomItemType.attachment &&
              element.value is int) {
            element.value = urls[element.value];
          }
        }
      }
      final isSuccess =
          await TaskService().createCustomTask(taskData: e.toMap());
      if (isSuccess) {
        Get.back();
      }
    } else {
      urls.clear();
    }
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
