import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/helpers/toast.dart';
import 'package:flutter_mekanix_app/services/auth_service.dart';
import 'package:flutter_mekanix_app/views/auth/change_password.dart';
import 'package:flutter_mekanix_app/views/auth/login.dart';
import 'package:flutter_mekanix_app/views/auth/otp.dart';
import 'package:flutter_mekanix_app/views/auth/verify_email.dart';
import 'package:flutter_mekanix_app/views/dashboard/dashboard.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  void saveUserInfo(Map<String, dynamic> userInfo) {
    storage.write('user_info', userInfo);
  }

  // RegisterUser
  Future<void> registerUser() async {
    if (signupFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      // Call the registerUser method in AuthService
      try {
        Map<String, dynamic> response = await authService.registerUser(
            firstName: fNameController.text.trim(),
            lastName: lNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim());

        if (response['status'] == 'success') {
          debugPrint('Registration successful');
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.green);

          Get.to(() => OtpScreen(
                verifyOtpForForgetPassword: false,
                email: emailController.text.trim(),
              ));
        } else {
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
        }
      } catch (e) {
        debugPrint('An error occurred during registration: $e');
        ToastMessage.showToastMessage(
            message: 'An error occurred during registration',
            backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  //verifyEmail
  Future<void> verifyEmail() async {
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('OTP: ${otpController.text.trim()}');

      try {
        Map<String, dynamic> response = await authService.verifyEmail(
          email: emailController.text.trim(),
          otp: otpController.text.trim(),
        );

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
              message: 'Email Verified Successfully',
              backgroundColor: Colors.green);
          Get.offAll(() => LoginScreen());
          clearAllControllers();
        } else {
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'An error occurred during email verification',
            backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  //loginUser
  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('Password: ${passwordController.text.trim()}');

      try {
        Map<String, dynamic> response = await authService.loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
              message: 'Login Successfully', backgroundColor: Colors.green);
          storage.write('token', response['token']);
          // controller.saveUserInfo(response['user']);
          saveUserInfo(response['user']);
          Get.offAll(() => const DashboardScreen(),
              transition: Transition.zoom);
          emailController.clear();
          passwordController.clear();
        } else if (response['message'] == 'Please Verify Your Email First') {
          Get.to(() => VerifyEmailScreen(), transition: Transition.rightToLeft);
          ToastMessage.showToastMessage(
              message: 'Please Verify Your Email First',
              backgroundColor: Colors.green);
          // emailController.clear();
          // passwordController.clear();
        } else {
          debugPrint('Error: ${response['message']}');
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again.',
            backgroundColor: Colors.green);
      } finally {
        isLoading.value = false;
      }
    }
  }

  //sendOtp
  Future<void> sendOtp({required bool verifyOtpForForgetPassword}) async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');

      try {
        Map<String, dynamic> response = await authService.sendOtp(
          email: emailController.text.trim(),
        );

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
              message: 'Please check your email, we have sent you an OTP',
              backgroundColor: Colors.green);
          // emailController.clear();
          Get.off(() => OtpScreen(
                verifyOtpForForgetPassword: verifyOtpForForgetPassword,
                email: emailController.text.trim(),
              ));
        } else {
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again.',
            backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> verifyOtp({required bool verifyOtpForForgetPassword}) async {
    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Email: ${emailController.text.trim()}');
      debugPrint('OTP: ${otpController.text.trim()}');

      try {
        Map<String, dynamic> response = await authService.verifyOtp(
          email: emailController.text.trim(),
          otp: otpController.text.trim(),
        );

        if (response['status'] == 'success') {
          debugPrint('verifyOtpForForgetPassword: $verifyOtpForForgetPassword');
          debugPrint('VERIFY OTP API CALLED SUCCESSFULLY');
          ToastMessage.showToastMessage(
              message: 'OTP Verified Successfully',
              backgroundColor: Colors.green);

          // Accessing the token correctly
          String token = response['data'][0]['token'];

          debugPrint('TokenReceived: $token');
          storage.write('token', token);
          verifyOtpForForgetPassword
              ? Get.offAll(() => ChangePasswordScreen())
              : Get.offAll(() => const DashboardScreen());
          emailController.clear();
          otpController.clear();
        } else {
          debugPrint('RESPONSE: ${response['message']}');
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
        }
      } catch (e) {
        debugPrint('Something went wrong. ${e.toString()}');
        ToastMessage.showToastMessage(
            message: 'Something went wrong, please try again.',
            backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    }
  }

  //changePassword
  Future<void> changePassword() async {
    if (passwordController.text.isNotEmpty ==
        confirmPasswordController.text.isNotEmpty) {
      isLoading.value = true;
      debugPrint('Password: ${passwordController.text.trim()}');
      debugPrint('ConfirmPassword: ${confirmPasswordController.text.trim()}');

      try {
        Map<String, dynamic> response = await authService.changePassword(
            password: passwordController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim(),
            token: storage.read('token'));

        if (response['status'] == 'success') {
          ToastMessage.showToastMessage(
              message: 'Password Changed Successfully',
              backgroundColor: Colors.green);
          passwordController.clear();
          confirmPasswordController.clear();
          Get.offAll(() => LoginScreen());
        } else {
          ToastMessage.showToastMessage(
              message: response['message'], backgroundColor: Colors.red);
        }
      } catch (e) {
        ToastMessage.showToastMessage(
            message: 'An error occurred during changing password',
            backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    } else {
      ToastMessage.showToastMessage(
        message: 'Passwords do not match',
        backgroundColor: Colors.red,
      );
    }
  }

  void clearAllControllers() {
    fNameController.clear();
    lNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    otpController.clear();
  }

  @override
  onClose() {
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

}
