import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParagraph(
                'RidezToHealth respects your privacy. This policy explains what data we collect, why we collect it, and how we use it to provide safe and reliable rides.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Information we collect',
                text:
                    'Account details such as name, phone number, and profile photo. Trip details such as pickup/dropoff, timestamps, and route. Device information such as app version and basic diagnostics. If you allow it, we collect location data to power ride matching and navigation.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'How we use your data',
                text:
                    'To create your account, process rides, improve routing, provide customer support, and enhance safety. We also use aggregated data to improve the app experience.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Sharing and disclosure',
                text:
                    'We share necessary trip and contact details with drivers to complete your ride. We do not sell your personal data. We may share data with service providers who help us operate the app, under strict confidentiality.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Your choices',
                text:
                    'You can update your profile, manage notification preferences, and disable location access in your device settings. Some features may not work without location access.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Security',
                text:
                    'We use reasonable safeguards to protect your data. No method is 100% secure, but we continuously review and improve our security practices.',
              ),
              const SizedBox(height: 20),
              _buildHeadingParagraph(
                heading: 'Contact us',
                text:
                    'If you have questions about this Privacy Policy, contact the RidezToHealth support team from within the app.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      maxLines: 20,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        color: Colors.white,
        height: 1.6,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildHeadingParagraph({
    required String heading,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _buildParagraph(text),
      ],
    );
  }
}
