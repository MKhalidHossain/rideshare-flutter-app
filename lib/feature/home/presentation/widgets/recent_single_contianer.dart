import 'package:flutter/material.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';

import '../../../../core/widgets/normal_custom_button.dart';

class SingleActivityORTripContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final String price;

  const SingleActivityORTripContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint – tweak if needed
        final bool isNarrow = constraints.maxWidth < 360;

        // Left side (icon + texts)
        Widget leftSide = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon bubble
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffBBCFF9).withOpacity(0.2),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),

            // Texts – allow them to wrap if needed
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title (16 white 500 from your extension)
                  title.text16White500(),
                  const SizedBox(height: 2),
                  // Subtitle
                  subTitle.text12Grey(),
                  const SizedBox(height: 2),
                  // Price
                  price.text12Grey(),
                ],
              ),
            ),
          ],
        );

        // Right side button
        final rightSide = SmallSemiTranparentButton(
          showIcon: true,
          sufixIcon: Icons.refresh,
          weight: isNarrow ? 90 : 100,
          text: 'Rebook',
          onPressed: () {},
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          child: isNarrow
              // On very small screens: stack vertically
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leftSide,
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: rightSide,
                    ),
                  ],
                )
              // On normal/wide screens: row with space between
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: leftSide),
                    const SizedBox(width: 12),
                    rightSide,
                  ],
                ),
        );
      },
    );
  }
}
