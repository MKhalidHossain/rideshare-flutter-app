import 'package:flutter/material.dart';

class WideCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showIcon;
  final IconData? sufixIcon;
  final double? height;

  const WideCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.showIcon = false,
    this.sufixIcon,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // Make it red like in your design
          gradient: LinearGradient(
            stops: [0.0, 0.4, 9.0],
            colors: [
              Color(0xff7B0100).withOpacity(0.8),
              Color(0xFFCE0000),
              Color(0xff7B0100).withOpacity(0.8),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showIcon && sufixIcon != null) ...[
              const SizedBox(width: 5),
              Icon(sufixIcon, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
