import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/app.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/helpers/dependency_injection.dart';
import 'core/onboarding/presentation/screens/constantSpashScreen.dart';
import 'core/onboarding/presentation/screens/onboarding1.dart';
import 'core/onboarding/presentation/screens/spashScreen.dart';
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

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController authController = Get.find<AuthController>();
  Future<bool>? _isFirstTimeInstaled;
  @override
  void initState() {
    super.initState();
    _isFirstTimeInstaled = authController.isFirstTimeInstall();
  }

  // isFirstTimeInstall() async {
  //   isFirstTimeInstaled = await authController.isFirstTimeInstall();
  //   print("form mainScreen isFirstTimeInstaled $isFirstTimeInstaled");
  //   return isFirstTimeInstaled;
  // }


  whichPageToNext(bool _isFirstTimeInstaled) {
    if (_isFirstTimeInstaled) {
      return SplashScreen(nextScreen: Onboarding1());
    } else if (authController.isLoggedIn()) {
      return AppMain();
    } else {
      return UserLoginScreen();
    }
  }

  // This widget is the root of your application.
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
      home: FutureBuilder<bool>(
        future: _isFirstTimeInstaled,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ConstantSplashScreen();
          } else {
            return whichPageToNext(snapshot.data!);
          }
        },
      ),

      // whichPageToNext(),
      //MapScreenTest(),
      // SearchDestinationScreen(),
      // RideConfirmedScreen(),
      // AppMain(),
      // SplashScreen(nextScreen: Onboarding1()),
    );
  }
}

