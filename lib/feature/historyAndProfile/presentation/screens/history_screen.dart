import 'package:flutter/material.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';

import '../../../home/presentation/widgets/recent_single_contianer.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: 'Your All Activity'.text22White(),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SingleActivityContainer(
                  title: 'New York City',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'Los Anageles',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'New York City',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'Los Anageles',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'New York City',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'Los Anageles',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'New York City',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
                SingleActivityContainer(
                  title: 'Los Anageles',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
