import 'package:flutter/material.dart';

class HeaderForAuthThreeMan extends StatelessWidget {
  final String text;
  const HeaderForAuthThreeMan({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 55),
        Stack(
          children: [
            Image.asset(
              'assets/images/banner/banner_for_auth.jpg',
              opacity: const AlwaysStoppedAnimation(
                0.2,
              ), // replace with your image
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 130,
              left: 20,
              right: 20,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 0.98,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 25,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/headers/star_logo.png',
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
