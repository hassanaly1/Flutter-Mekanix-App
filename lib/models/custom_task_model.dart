class MyCustomTask {
  final String? id;
  final String name;
  final String? customerName, customerEmail;
  bool isForm, isTemplate;
  final List<MyFormSection> formSections;

  MyCustomTask({
    this.id,
    required this.name,
    this.customerName,
    this.customerEmail,
    required this.isForm,
    required this.isTemplate,
    required this.formSections,
  });

  Map<String, dynamic> toMap() {
    return {
      'is_template': isTemplate.toString(),
      'is_form': isForm.toString(),
      'name': name,
      'formSections': formSections.map((e) => e.toMap()).toList(),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return MyCustomTask(
      id: map['_id'],
      name: map['name'],
      customerName: map['customer_name'],
      customerEmail: map['customer_email'],
      isForm: !map['is_template'],
      isTemplate: map['is_template'],
      formSections: map["formSections"] == null
          ? []
          : List<MyFormSection>.from(
              map["formSections"]!.map((x) => MyFormSection.fromMap(x)),
            ),
    );
  }
}

class MyFormSection {
  MyFormSection({required this.heading, required this.elements});

  final String heading;
  final List<MyCustomElementModel> elements;

  Map<String, dynamic> toMap() {
    return {
      'heading': heading,
      'elements': elements.map((e) => e.toMap()).toList(),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return MyFormSection(
      heading: map['heading'],
      elements: map["elements"] == null
          ? []
          : List<MyCustomElementModel>.from(
              map["elements"]!.map((x) => MyCustomElementModel.fromMap(x)),
            ),
    );
  }
}

enum MyCustomItemType { textfield, textarea, radiobutton, checkbox, attachment }

String? _typeInString(MyCustomItemType? type) => type?.name;

MyCustomItemType? _typeFromString(String? type) {
  switch (type) {
    case 'textfield':
      return MyCustomItemType.textfield;
    case 'textarea':
      return MyCustomItemType.textarea;
    case 'radiobutton':
      return MyCustomItemType.radiobutton;
    case 'checkbox':
      return MyCustomItemType.checkbox;
    case 'attachment':
      return MyCustomItemType.attachment;
    default:
      return null;
  }
}

class MyCustomElementModel {
  final String? label;
  final List<String>? options;
  final MyCustomItemType? type;
  dynamic value;

  MyCustomElementModel({this.label, this.options, this.type, this.value});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'options': options,
      'type': _typeInString(type),
      'value': value,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    print(map['options']);
    return MyCustomElementModel(
      label: map['label'] ?? '',
      options: map['options'] == null ? [] : List<String>.from(map['options']),
      type: _typeFromString(map['type']),
      value: map['value'],
    );
  }
}
// 'value': type == MyCustomItemType.textfield ||
//         type == MyCustomItemType.textarea
//     ? value.text.trim()
//     : type == MyCustomItemType.radiobutton
//         ? value.value
//         : type == MyCustomItemType.checkbox
//             ? value.value
//             : type == MyCustomItemType.attachment
//                 ? (value is int ? value : null)
//                 : null
