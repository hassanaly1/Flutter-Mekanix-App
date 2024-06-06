import 'package:flutter_mekanix_app/controllers/auth_controllers.dart';
import 'package:flutter_mekanix_app/helpers/appcolors.dart';
import 'package:flutter_mekanix_app/helpers/custom_button.dart';
import 'package:flutter_mekanix_app/helpers/custom_text.dart';
import 'package:flutter_mekanix_app/helpers/reusable_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_mekanix_app/helpers/toast.dart';
import 'package:flutter_mekanix_app/helpers/validator.dart';
import 'package:flutter_mekanix_app/views/auth/login.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/auth-background.png', fit: BoxFit.cover),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: context.height * 0.05,
                        bottom: context.height * 0.05),
                    child: Image.asset('assets/images/app-logo.png',
                        height: context.height * 0.12, fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.02,
                      horizontal: context.width * 0.02),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          spreadRadius: 5.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ]),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Opacity(
                          opacity: 0.3,
                          child: Image.asset(
                            'assets/images/gear.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.width > 700
                                ? context.width * 0.2
                                : context.width * 0.1),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextWidget(
                                text: 'Register Account',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomTextWidget(
                                text:
                                    'Fill the Details to register your account',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                fontStyle: FontStyle.italic,
                                maxLines: 4,
                              ),
                              Form(
                                key: controller.signupFormKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(height: context.height * 0.03),
                                    ReUsableTextField(
                                      controller: controller.fNameController,
                                      hintText: 'First Name',
                                      prefixIcon: Icon(
                                        Icons.account_circle_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                                      validator: (val) =>
                                          AppValidator.validateEmptyText(
                                              value: val,
                                              fieldName: 'First Name'),
                                    ),
                                    ReUsableTextField(
                                      controller: controller.lNameController,
                                      hintText: 'Last Name',
                                      prefixIcon: Icon(
                                        Icons.account_circle_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                                      validator: (val) =>
                                          AppValidator.validateEmptyText(
                                              value: val,
                                              fieldName: 'Last Name'),
                                    ),
                                    ReUsableTextField(
                                      controller: controller.emailController,
                                      hintText: 'Email',
                                      keyboardType: TextInputType.emailAddress,
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.primaryColor,
                                      ),
                                      validator: (val) =>
                                          AppValidator.validateEmail(
                                              value: val),
                                    ),
                                    ReUsableTextField(
                                      controller: controller.passwordController,
                                      hintText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.lock_open_rounded,
                                        color: AppColors.primaryColor,
                                      ),
                                      validator: (val) =>
                                          AppValidator.validatePassword(
                                              value: val),
                                    ),
                                    ReUsableTextField(
                                      controller:
                                          controller.confirmPasswordController,
                                      hintText: 'Confirm Password',
                                      prefixIcon: Icon(
                                        Icons.lock_open_rounded,
                                        color: AppColors.primaryColor,
                                      ),
                                      validator: (val) =>
                                          AppValidator.validatePassword(
                                              value: val),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: context.height * 0.01),
                              Obx(
                                () => CustomButton(
                                  isLoading: controller.isLoading.value,
                                  buttonText: 'Register',
                                  onTap: () {
                                    if (controller.passwordController.text ==
                                        controller
                                            .confirmPasswordController.text) {
                                      controller.registerUser();
                                    } else {
                                      ToastMessage.showToastMessage(
                                          message: 'Passwords do not match',
                                          backgroundColor: Colors.red);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: context.height * 0.02),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => LoginScreen(),
                                      transition: Transition.size,
                                      duration: const Duration(seconds: 1),
                                    );
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Already have a account? ',
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                      children: [
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(
                                              color: AppColors.blueTextColor,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
