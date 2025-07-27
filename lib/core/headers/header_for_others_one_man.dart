
import 'package:flutter/material.dart';

import '../widgets/three_icon_image_for_header.dart';

class HeaderForOthers extends StatelessWidget {
  final bool isShowSearch;
  final String text;
  final String? image;

  const HeaderForOthers({super.key,  this.isShowSearch =true, required this.text, this.image});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 55),
        Stack(
          children: [
            image != null && image!.isNotEmpty
                ? Image.network(
                  image!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                )
                : Image.asset(
                  'assets/images/banner/banner_for_others.jpg',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
            Positioned(
              top: 125,
              left: 20,
              right: 20,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      text ?? 'Blog Title',
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
              top: 40,
              left: 20,
              right: 20,
              child: ThreeIconImageForHeader(isShowSearch: isShowSearch),
            ),
          ],
        ),
      ],
    );
  }
}
