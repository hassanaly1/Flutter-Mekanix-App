import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/controllers/dashboard_controller.dart';
import 'package:flutter_mekanix_app/controllers/universal_controller.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_button.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_textfield.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/helpers/toast.dart';
import 'package:flutter_mekanix_app/services/auth_service.dart';
import 'package:flutter_mekanix_app/views/auth/login.dart';
import 'package:flutter_mekanix_app/views/task/widgets/heading_and_textfield.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSection extends StatefulWidget {
  final SideMenuController sideMenu;

  const ProfileSection({super.key, required this.sideMenu});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final UniversalController universalController = Get.find();
  RxBool isLoading = false.obs;
  RxBool circularLoading = false.obs;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          widget.sideMenu.changePage(0);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProfileSectionView(context),
          // child: DefaultTabController(
          //   length: 2,
          //   child: Column(
          //     children: [
          //       const CustomTabBar(
          //           title1: 'Profile', title2: 'Change Password'),
          //       Expanded(
          //         child: TabBarView(
          //           children: [
          //             ProfileSectionView(context),
          //             ChangePasswordSectionView(context),
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }

  SingleChildScrollView ProfileSectionView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 22.0),
          InkWell(
            onTap: updateUserImage,
            child: Obx(() => Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage: universalController
                              .userImageURL.value.isNotEmpty
                          ? NetworkImage(universalController.userImageURL.value)
                          : const AssetImage('assets/images/placeholder.png')
                              as ImageProvider,
                    ),
                    if (circularLoading.value)
                      CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 2.0,
                      ),
                    // Show circular loading indicator
                  ],
                )),
          ),
          const SizedBox(height: 12.0),
          Obx(
            () => CustomTextWidget(
              text: (universalController.userInfo.value['first_name'] ?? '') +
                  ' ' +
                  (universalController.userInfo['last_name'] ?? ''),
              fontWeight: FontWeight.w500,
              fontSize: 20,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
          CustomTextWidget(
            text: universalController.userInfo.value['email'] ?? '',
            fontWeight: FontWeight.w300,
            fontSize: 14,
            textAlign: TextAlign.center,
            maxLines: 2,
            textColor: AppColors.lightTextColor,
          ),
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(
                  vertical: context.height * 0.03,
                  horizontal: context.width * 0.01),
              child: Column(
                children: [
                  ReUsableTextField(
                      onTap: () {
                        firstNameController.text =
                            universalController.userInfo.value['first_name'];
                      },
                      controller: firstNameController,
                      hintText:
                          universalController.userInfo.value['first_name'] ??
                              ''),
                  ReUsableTextField(
                      onTap: () {
                        lastNameController.text =
                            universalController.userInfo.value['last_name'];
                      },
                      controller: lastNameController,
                      hintText:
                          universalController.userInfo.value['last_name'] ??
                              ''),
                  ReUsableTextField(
                      onTap: () {
                        ToastMessage.showToastMessage(
                            message: 'You are not allowed to change your email',
                            backgroundColor: Colors.red);
                      },
                      hintText:
                          universalController.userInfo.value['email'] ?? '',
                      readOnly: true),
                  Obx(
                    () => CustomButton(
                      isLoading: isLoading.value,
                      buttonText: 'Update',
                      onTap: () {
                        updateProfileInfo();
                      },
                      usePrimaryColor: true,
                      textColor: Colors.black87,
                    ),
                  ),
                  CustomButton(
                    isLoading: false,
                    buttonText: 'Logout',
                    onTap: () {
                      storage.remove('token');
                      storage.remove('user_info');
                      Get.delete<UniversalController>();
                      Get.delete<DashboardController>();
                      // Get.delete<EnginesController>();
                      Get.offAll(() => LoginScreen());
                    },
                    textColor: Colors.white60,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView ChangePasswordSectionView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.height * 0.03,
                horizontal: context.width * 0.01),
            child: Column(
              children: [
                const CustomTextWidget(
                  text: 'Change Password',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 22.0),
                HeadingAndTextfield(
                  controller: firstNameController,
                  title: 'Current Password',
                ),
                HeadingAndTextfield(
                  title: 'New Password',
                  controller: lastNameController,
                ),
                const HeadingAndTextfield(
                  title: 'Confirm New Password',
                ),
                Obx(
                  () => CustomButton(
                    isLoading: isLoading.value,
                    buttonText: 'Change Password',
                    onTap: () {
                      updateProfileInfo();
                    },
                    usePrimaryColor: true,
                    textColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateProfileInfo() async {
    try {
      isLoading.value = true;
      bool success = await AuthService().updateProfile(
          firstName: firstNameController.text.trim().isEmpty
              ? universalController.userInfo.value['first_name']
              : firstNameController.text.trim(),
          lastName: lastNameController.text.trim().isEmpty
              ? universalController.userInfo.value['last_name']
              : lastNameController.text.trim(),
          // userImageInBytes: universalController.userImageInBytes!,
          token: storage.read('token'));
      isLoading.value = false;

      if (success) {
        setState(() {});
        ToastMessage.showToastMessage(
            message: 'Profile updated successfully',
            backgroundColor: Colors.green);
        // Profile update successful
      } else {
        // Profile update failed
        ToastMessage.showToastMessage(
            message: 'Something went wrong, try again',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      ToastMessage.showToastMessage(
          message: 'Something went wrong, try again',
          backgroundColor: Colors.red);
      isLoading.value = false;
    }
  }

  Future<void> updateUserImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      circularLoading.value = true;
      if (image != null) {
        universalController.userImage = image;
        universalController.userImageURL.value = image.path;
        universalController.userImageInBytes =
            (await universalController.userImage?.readAsBytes())!;
        debugPrint('UserImageInBytes: ${universalController.userImageInBytes}');

        UpdateUserImageResult result = await AuthService().updateUserImage(
          token: storage.read('token'),
          engineImageInBytes: universalController.userImageInBytes!,
        );

        if (result.isSuccess) {
          if (result.userData != null) {
            debugPrint(
                'AfterUpdateProfileLink: ${result.userData!['profile']}');
            universalController.setUserImageUrl = result.userData!['profile'];
            debugPrint(
                'AfterUpdate: ${universalController.userImageURL.value}');
            ToastMessage.showToastMessage(
                message: 'Profile Image Updated',
                backgroundColor: Colors.green);
          } else {
            ToastMessage.showToastMessage(
                message: 'Something went wrong, try again',
                backgroundColor: Colors.yellow);
          }
        } else {
          ToastMessage.showToastMessage(
              message: 'Something went wrong, try again',
              backgroundColor: Colors.red);
        }
        circularLoading.value = false;
        setState(() {});
      } else {
        debugPrint('No image selected');
        ToastMessage.showToastMessage(
            message: 'No image selected', backgroundColor: Colors.red);
        circularLoading.value = false;
      }
    } catch (e) {
      // Handle any errors that occur during the execution of the function
      debugPrint('Error occurred: $e');
      ToastMessage.showToastMessage(
          message: 'An error occurred: $e', backgroundColor: Colors.red);
    }
  }
}
