import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';
import 'package:get/get.dart';

class CustomCheckboxWidget extends StatelessWidget {
  final String heading;
  final List<String> options, selected;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;
  final Function(List<String>) onChange;

  const CustomCheckboxWidget({
    super.key,
    required this.options,
    required this.selected,
    required this.heading,
    required this.onChange,
    this.showDeleteIcon = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    var selectedValues = <String>[...selected].obs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          text: heading,
          fontWeight: FontWeight.w500,
          maxLines: 2,
        ),
        Obx(
          () => ReUsableContainer(
            showDeleteIcon: showDeleteIcon,
            onDelete: onDelete,
            child: Column(
              children: options
                  .map((option) => CheckboxListTile(
                        activeColor: AppColors.blueTextColor,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: CustomTextWidget(text: option),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedValues.contains(option),
                        onChanged: (bool? value) {
                          if (value != null) {
                            selectedValues.contains(option)
                                ? selectedValues.remove(option)
                                : selectedValues.add(option);
                            onChange(selectedValues);
                          }
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
