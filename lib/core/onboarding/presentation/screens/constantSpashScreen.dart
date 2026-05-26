import 'package:flutter/material.dart';
import 'package:rideztohealth/core/widgets/app_scaffold.dart';

class ConstantSplashScreen extends StatelessWidget {
  const ConstantSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      body: FittedBox(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 230,
                height: 200,
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
