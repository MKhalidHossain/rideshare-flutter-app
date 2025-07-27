import 'package:flutter/material.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';

class SavedPlaceSingeContainer extends StatelessWidget {
  final String title;
  final String subTitle;

  const SavedPlaceSingeContainer({super.key, required this.title, required this.subTitle});

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
                  color: Colors.white24,
                ),
                child: const Icon(
                  Icons.bookmark_border_outlined,

                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title.text16White500(), subTitle.text12Grey()],
              ),
            ],
          ),
          // SmallSemiTranparentButton(
          //   showIcon: true,
          //   sufixIcon: Icons.refresh,
          //   weight: 100,
          //   text: 'Rebook',
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
