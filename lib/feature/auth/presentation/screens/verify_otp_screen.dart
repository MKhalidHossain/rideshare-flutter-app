import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import 'package:rideztohealth/core/common/button/button_widget.dart';

import '../../../../core/themes/app_color.dart';


class VerifyOtpScreen extends StatefulWidget {
  final String email;

  VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController pinController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final focusedBorderColor = AppColors.primaryColor;
    const fillColor = AppColors.background;
    const borderColor = AppColors.secondayText;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 22, color: AppColors.primaryTextBlack),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          "Enter security code",
          style: TextStyle(
            color: AppColors.primaryTextBlack,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Info Text
              Text(
                "Please check your Email for a message with your code. Your code is 6 numbers long.",
                style: TextStyle(
                  color: AppColors.secondayText,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              /// Title
              Text(
                'Enter OTP',
                style: TextStyle(
                  color: AppColors.primaryTextBlack,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Enter your received OTP',
                style: TextStyle(color: AppColors.secondayText, fontSize: 18),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              /// OTP Input
              Pinput(
                length: 6,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) => debugPrint('Completed: $pin'),
                onChanged: (value) => debugPrint('Changed: $value'),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.red),
                ),
              ),

              const SizedBox(height: 12),

              /// Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't Receive OTP",
                    style: TextStyle(color: AppColors.secondayText),
                  ),
                  TextButton(
                    onPressed: () {
                      // authController.resendOtp(widget.email);
                    },
                    child: Text(
                      "RESEND OTP",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),
              context.primaryButton(
                onPressed: () {
                  final String otp = pinController.text;

                  if (otp.length == 6) {
                    // authController.otpVerification(otp, widget.email);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid 6-digit code.'),
                      ),
                    );
                  }
                },
                text: "Verify",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
