
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  const ProfileAvatar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final UniversalController universalController = Get.find();
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            // backgroundImage: MemoryImage(controller.userImageInBytes!),
            // backgroundImage: universalController.userImageURL.value != ''
            //     ? NetworkImage(universalController.userImageURL.value)
            //     : const AssetImage('assets/images/placeholder.png')
            //         as ImageProvider
          ),
      ),
    );
  }
}
