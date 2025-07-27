import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rideztohealth/app.dart';
import 'package:rideztohealth/feature/map/presentation/screens/map_screen_test.dart';
import 'core/onboarding/presentation/screens/onboarding1.dart';
import 'core/onboarding/presentation/screens/spashScreen.dart';
import 'feature/map/bindings/initial_binding.dart';
import 'feature/map/presentation/screens/search_destination_screen.dart';
import 'navigation/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      home:
          //MapScreenTest(),
          // SearchDestinationScreen(),
          AppMain(),
      //  SplashScreen(nextScreen: Onboarding1()),
    );
  }
}
