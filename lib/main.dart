import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/app.dart';
import 'package:rideztohealth/helpers/dependency_injection.dart';
import 'feature/map/bindings/initial_binding.dart';
// I think that we need to check isLoggedIn  , is work or not

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      title: 'RidezToHealth',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(
          0xFF303644,
        ), 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home: const AppMain(),
    );
  }
}
