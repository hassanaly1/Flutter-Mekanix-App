import 'package:flutter/material.dart';
import 'package:flutter_mekanix_app/helpers/storage_helper.dart';
import 'package:flutter_mekanix_app/views/auth/login.dart';
import 'package:flutter_mekanix_app/views/auth/onboarding/onboarding.dart';
import 'package:flutter_mekanix_app/views/dashboard/dashboard.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = storage.read('isFirstTime') ?? true;

    return GetMaterialApp(
      title: 'Mechanix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isFirstTime == true
          ? const OnBoardingScreen()
          : storage.read('token') != null
          ? const DashboardScreen()
          : LoginScreen(),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
