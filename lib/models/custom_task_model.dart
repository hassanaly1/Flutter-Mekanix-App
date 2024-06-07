import 'dart:typed_data';

class MyCustomTask {
  final String name;
  final List<MyFormSection>? formSections;

  MyCustomTask({required this.name, this.formSections});
}

class MyFormSection {
  MyFormSection({required this.heading, required this.elements});

  final String heading;
  final List<MyCustomItemModel> elements;
}

enum MyCustomItemType { textfield, textArea, radioButton, checkbox, attachment }

String? _typeInString(MyCustomItemType? type) => type?.name;

MyCustomItemType? _typeFromString(String? type) {
  switch (type) {
    case 'textfield':
      return MyCustomItemType.textfield;
    case 'textArea':
      return MyCustomItemType.textArea;
    case 'radioButton':
      return MyCustomItemType.radioButton;
    case 'checkbox':
      return MyCustomItemType.checkbox;
    case 'attachment':
      return MyCustomItemType.attachment;
    default:
      return null;
  }
}

class MyCustomItemModel {
  final String? label;
  final List<String>? options;
  final MyCustomItemType? type;
  dynamic controller;

  MyCustomItemModel({this.label, this.options, this.type, this.controller});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'options': options,
      'type': _typeInString(type),
      'value': type == MyCustomItemType.textfield ||
              type == MyCustomItemType.textArea
          ? controller.text.trim()
          : type == MyCustomItemType.radioButton
              ? controller.value
              : type == MyCustomItemType.checkbox
                  ? controller.value
                  : type == MyCustomItemType.attachment
                      ? (controller is Uint8List ? controller : null)
                      : null
    };
  }

  fromMap(Map<String, dynamic> map) {
    return MyCustomItemModel(
      label: map['heading'],
      options: map['options'],
      type: _typeFromString(map['type']),
      controller: map['controller'],
    );
  }
}
