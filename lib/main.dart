import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/views/auth/login.dart';
import 'package:flutter_mekanix_app/views/auth/onboarding/onboarding.dart';
import 'package:flutter_mekanix_app/views/dashboard/dashboard.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mechanix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthStatusCheckController extends GetxController {
  var isFirstTime = true.obs;
  var isTokenValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    isFirstTime.value = storage.read('isFirstTime') ?? true;
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    var authResponse = await postAuthStateChange();
    bool tokenValid = authResponse['statusCode'] == 200;
    isTokenValid.value = tokenValid;

    if (!tokenValid && storage.read('token') != null) {
      _showSessionExpiredMessage();
    } else if (tokenValid) {
      // If the token is valid, you can handle the user and token if needed
      var user = authResponse['user'];
      var token = authResponse['token'];
      storage.write('user_info', user);
      storage.write('token', token);
      debugPrint('TokenAtStorage: ${storage.read('token')}');
      debugPrint('UserAtStorage: ${storage.read('user_info')}');
    }
  }

  // Future<void> _checkAuthState() async {
  //   bool tokenValid = await postAuthStateChange();
  //   isTokenValid.value = tokenValid;
  //   if (!tokenValid && storage.read('token') != null) {
  //     _showSessionExpiredMessage();
  //   }
  // }

  void _showSessionExpiredMessage() {
    Get.snackbar(
      "Session Expired",
      "Your session has expired. Please log in again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}

class AuthCheck extends StatelessWidget {
  final AuthStatusCheckController authController =
      Get.put(AuthStatusCheckController());

  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isFirstTime.value) {
        return const OnBoardingScreen();
      } else if (storage.read('token') != null &&
          authController.isTokenValid.value) {
        return const DashboardScreen();
      } else {
        return LoginScreen();
      }
    });
  }
}

Future<Map<String, dynamic>> postAuthStateChange() async {
  var url = Uri.parse(
      'https://mechanixapi-production.up.railway.app/api/auth/onauthstatechange');
  var token = storage.read('token');
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  var response = await http.post(
    url,
    headers: headers,
  );

  debugPrint('StatusCode: ${response.statusCode} + ${response.reasonPhrase}');
  if (response.statusCode == 200) {
    var responseBody = jsonDecode(response.body);
    var user = responseBody['user'];
    var token = responseBody['token'];
    var statusCode = response.statusCode;
    return {
      'user': user,
      'token': token,
      'statusCode': statusCode,
    };
  } else if (response.statusCode == 402) {
    return {
      'user': null,
      'token': null,
      'statusCode': response.statusCode,
    };
  } else {
    return {
      'user': null,
      'token': null,
      'statusCode': response.statusCode,
    };
  }
}
