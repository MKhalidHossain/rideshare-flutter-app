import 'package:flutter/material.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';

import '../../../home/presentation/widgets/saved_pleaces_single_container.dart';

class SavedPlaceScreen extends StatefulWidget {
  const SavedPlaceScreen({super.key});

  @override
  State<SavedPlaceScreen> createState() => _SavedPlaceScreenState();
}

class _SavedPlaceScreenState extends State<SavedPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.white),
          centerTitle: false,
          title: 'Your Saved Places'.text22White(),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Mom\'s House',
                  subTitle: '321 Family Rd',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Airport',
                  subTitle: 'International Terminal',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Mom\'s House',
                  subTitle: '321 Family Rd',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Airport',
                  subTitle: 'International Terminal',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Mom\'s House',
                  subTitle: '321 Family Rd',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Airport',
                  subTitle: 'International Terminal',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Mom\'s House',
                  subTitle: '321 Family Rd',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Airport',
                  subTitle: 'International Terminal',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Mom\'s House',
                  subTitle: '321 Family Rd',
                ),
                const SizedBox(height: 16),
                SavedPlaceSingeContainer(
                  title: 'Airport',
                  subTitle: 'International Terminal',
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
