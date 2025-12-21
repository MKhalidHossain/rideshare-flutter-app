import 'package:flutter/material.dart';

class RoundedButtonWithArrowAndProgress extends StatefulWidget {
  final VoidCallback onTap;
  final bool isIcon;

  final int percent;

  const RoundedButtonWithArrowAndProgress({
    super.key,
    required this.onTap,
    this.isIcon = true,
    required this.percent,
  });

  @override
  State<RoundedButtonWithArrowAndProgress> createState() =>
      _RoundedButtonWithArrowAndProgressState();
}

class _RoundedButtonWithArrowAndProgressState
    extends State<RoundedButtonWithArrowAndProgress> {
  @override
  Widget build(BuildContext context) {
    return CircularPercentWidgetForButton(
      percent: widget.percent, // Example percentage
      size: 85, // Example size
      fontColor: Colors.white, // Example font color
      onTap: widget.onTap,
      isIcon: widget.isIcon,
      
    );
  }
}

class CircularPercentWidgetForButton extends StatefulWidget {
  final int percent; // 0–100
  final double size; // The total size of the circular widget
  final Color fontColor;
  final VoidCallback onTap;
  final bool isIcon;

  const CircularPercentWidgetForButton({
    super.key,
    required this.percent,
    required this.size,
    this.fontColor = Colors.black,
    required this.onTap,
    this.isIcon = true,
  });

  @override
  State<CircularPercentWidgetForButton> createState() =>
      _CircularPercentWidgetForButtonState();
}

class _CircularPercentWidgetForButtonState
    extends State<CircularPercentWidgetForButton> {
  @override
  Widget build(BuildContext context) {
    final double clampedPercent = widget.percent.clamp(0, 100).toDouble();
    final double progressValue = clampedPercent / 100.0;
    final double strokeWidth = widget.size * 0.05;
    final double fontSize = widget.size * 0.28;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              value: progressValue,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(clampedPercent),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: widget.size - 10,
              height: widget.size - 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xffCE0000), Color(0xff7B0100)],
                ),
              ),
              child: Center(
                child: widget.isIcon
                    ? Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: widget.size * 0.4, // Adjust icon size as needed
                      )
                    : Text(
                        'Go',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                          color: widget.fontColor,
                        ),
                      ),
              ),
            ),
          ),
          // Text(
          //   '${clampedPercent.toInt()}%',
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: fontSize,
          //     color: widget.fontColor,
          //   ),
          // ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percent) {
    if (percent >= 75) return Color(0xff7B0100);
    if (percent >= 50) return Color(0xffCE0000);
    return Color(0xffCE0000);
  }
}
