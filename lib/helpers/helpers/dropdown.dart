// import 'package:flutter/material.dart';
// import 'package:flutter_mekanix_app/helpers/helpers/appcolors.dart';
// import 'package:flutter_mekanix_app/helpers/helpers/custom_text.dart';
// import 'package:get/get.dart';
//
// class CustomDropdown extends StatelessWidget {
//   final String hintText;
//   final List<EngineModel> items;
//   final void Function(EngineModel?)? onChanged;
//
//   const CustomDropdown({
//     super.key,
//     required this.items,
//     required this.onChanged,
//     required this.hintText,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ReUsableContainer(
//       child: DropdownButtonFormField(
//
//         padding: EdgeInsets.zero,
//         isExpanded: true,
//         hint: Text(hintText),
//         dropdownColor: Colors.white,
//         borderRadius: BorderRadius.circular(12.0),
//         icon: const Icon(Icons.keyboard_arrow_down_rounded),
//         style: TextStyle(
//           fontFamily: 'Poppins',
//           fontSize: 12,
//           fontWeight: FontWeight.w300,
//           color: AppColors.lightTextColor,
//         ),
//
//         decoration: InputDecoration(
//           fillColor: Colors.white,
//           filled: true,
//           border: const OutlineInputBorder(borderSide: BorderSide.none),
//           constraints: BoxConstraints(maxHeight: context.height * 0.08),
//         ),
//
//         items: items
//             .map((options) =>
//             DropdownMenuItem(
//                 value: options,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomTextWidget(
//                       text: options.name ?? '',
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w300,
//                       textColor: AppColors.textColor,
//                     ),
//                     // CustomTextWidget(
//                     //   text: '  (${options.isGenerator ? 'Generator' : 'Chassis'})',
//                     //   fontSize: 12.0,
//                     //   fontWeight: FontWeight.w300,
//                     //   textColor: AppColors.textColor,
//                     // ),
//                   ],
//                 )))
//             .toList(),
//         onChanged: onChanged,
//         // onChanged: (value) {
//         //   if (!controller.selectedTeams.contains(value)) {
//         //     controller.selectedTeams.addNonNull(value!);
//         //   } else {
//         //     ToastMessage.showToastMessage(
//         //         message: '${value?.name} is already selected.',
//         //         backgroundColor: Colors.red);
//         //   }
//         //   print(controller.selectedTeams.length);
//         // },
//       ),
//     );
//   }
// }
