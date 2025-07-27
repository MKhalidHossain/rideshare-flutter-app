import 'package:flutter/material.dart';

import '../widgets/three_icon_image_for_header.dart';

class HeaderForAboutThereeMan extends StatelessWidget {
  final String text;
  const HeaderForAboutThereeMan({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 55),
        Stack(
          children: [
            Image.asset(
              'assets/images/banner/banner_for_auth.jpg', // replace with your image
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 150,
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
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 0.98,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: ThreeIconImageForHeader(),
            ),
          ],
        ),
      ],
    );
  }
}
