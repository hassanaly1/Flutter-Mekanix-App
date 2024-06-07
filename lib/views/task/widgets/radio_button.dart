import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_container.dart';

class CustomRadioButton extends StatelessWidget {
  final String heading;
  final List<String> options;
  final Rx<String?> selectedOption;
  final bool showDeleteIcon;
  final VoidCallback? onDelete;

  const CustomRadioButton({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.heading,
    this.showDeleteIcon = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6.0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Radio(
                        visualDensity: VisualDensity.compact,
                        activeColor: AppColors.blueTextColor,
                        value: option,
                        groupValue: selectedOption.value,
                        onChanged: (value) {
                          selectedOption.value = value.toString();
                        },
                      ),
                      CustomTextWidget(text: option),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
