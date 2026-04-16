import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/widgets/app_scaffold.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({required this.nextScreen, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(widget.nextScreen);
    });
  }
  // late VideoPlayerController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.asset("assets/sp.mp4")
  //     ..initialize().then((_) {
  //       setState(() {}); // Ensure the widget rebuilds when initialized
  //       _controller.play();

  //       // Wait for video duration + 6 seconds before navigating
  //       Future.delayed(
  //         _controller.value.duration + const Duration(seconds: 2),
  //         () {
  //           Get.offAll(widget.nextScreen);
  //         },
  //       );
  //     });
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AppScaffold(
      body: FittedBox(
        child: Container(
          width: size.width,
          height: size.height,
          // color: Color(0xff101010),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SizedBox(height: size.height * .32),
              Container(
                width: 230,
                height: 200,
                // height: _controller.value.size.height * 0.25,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                  width: 230,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
