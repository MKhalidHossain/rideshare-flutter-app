import 'package:flutter/material.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';

import '../../../../core/widgets/normal_custom_button.dart';

class SingleActivityContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final String price;

  const SingleActivityContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffBBCFF9).withOpacity(0.2),
                ),
                child: const Icon(
                  Icons.location_on_outlined,

                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title.text16White500(),
                  subTitle.text12Grey(),
                  price.text12Grey(),
                ],
              ),
            ],
          ),
          SmallSemiTranparentButton(
            showIcon: true,
            sufixIcon: Icons.refresh,
            weight: 100,
            text: 'Rebook',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}