import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/app.dart';
import 'package:rideztohealth/helpers/dependency_injection.dart';
import 'feature/map/bindings/initial_binding.dart';
// I think that we need to check isLoggedIn  , is work or not

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  // if (Get.find<AuthController>().isFirstTimeInstall()) {
  //   print('App is first time install');

  //   // if permission is required need to use those requestPermissions according to commanders Rattings r
  //   // Request storage permission here
  //   // await requestPermissions();

  //   Get.find<AuthController>().setFirstTimeInstall();
  // } else {
  //   print('App is not first time install');
  // }


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
        ), // background color here
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        //background: const Color(0xFF303644), // Optional: sets default background in color scheme
      ),
      // initialBinding: InitialBinding(),
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home: const AppMain(),

      // whichPageToNext(),
      //MapScreenTest(),
      // SearchDestinationScreen(),
      // RideConfirmedScreen(),
      // AppMain(),
      // SplashScreen(nextScreen: Onboarding1()),
    );
  }
}
