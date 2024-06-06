import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UniversalController extends GetxController {
  RxBool isLoading = false.obs;

  XFile? userImage;
  RxString userImageURL = ''.obs;
  Uint8List? userImageInBytes;
  RxMap userInfo = {}.obs;

  set setUserImageUrl(String value) {
    userImageURL.value = value;
    update();
  }
  final RxInt currentPage = 1.obs;
  @override
  void onInit() async {
    super.onInit();
    userInfo.value = storage.read('user_info') ?? {};
    userImageURL.value = storage.read('user_info')['profile'];
    debugPrint('UserImageAtStart: $userImageURL');
  }

  updateUserInfo(Map<String, dynamic> userInfo) {
    this.userInfo.value = userInfo;
    storage.write('user_info', userInfo);
  }
}
