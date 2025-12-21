import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/wide_custom_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final otpVerifyType;

  const VerifyOtpScreen({
    super.key,
    required this.email,
    required this.otpVerifyType,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController pinController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  /// helper function for responsive text size
  double scaleText(double factor, {double min = 12, double max = 28}) {
    final width = MediaQuery.of(context).size.width;
    return (width * factor).clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final focusedBorderColor = AppColors.context(context).primaryColor;
    final fillColor = const Color(0xffFFFFFF).withOpacity(0.1);
    final borderColor = AppColors.context(context).secondaryAccentColor;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: scaleText(0.055, min: 18, max: 24), // PIN text
        color: AppColors.context(context).textColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

    return GetBuilder<AuthController>(
      builder: (authController) {
        return AppScaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: height * 0.6),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: height * 0.06),
                            const AppLogo(),
                            SizedBox(height: height * 0.06),

                            /// Title
                            Text(
                              "Enter OTP",
                              style: TextStyle(
                                color: AppColors.context(context).textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: scaleText(0.07, min: 20, max: 28),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.012),

                            /// Subtitle
                            Text(
                              "Enter the OTP you received",
                              style: TextStyle(
                                color: AppColors.context(context).textColor,
                                fontWeight: FontWeight.w400,
                                fontSize: scaleText(0.045, min: 14, max: 18),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: height * 0.06),

                            /// OTP Input
                            Pinput(
                              length: 6,
                              controller: pinController,
                              focusNode: focusNode,
                              defaultPinTheme: defaultPinTheme,
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              onCompleted: (pin) =>
                                  debugPrint('Completed: $pin'),
                              onChanged: (value) =>
                                  debugPrint('Changed: $value'),
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!
                                    .copyWith(
                                      border: Border.all(
                                        color: focusedBorderColor,
                                      ),
                                    ),
                              ),
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!
                                    .copyWith(
                                      color: fillColor,
                                      border: Border.all(
                                        color: focusedBorderColor,
                                      ),
                                    ),
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: Colors.red),
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            /// Resend
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive OTP?",
                                  style: TextStyle(
                                    fontSize: scaleText(
                                      0.035,
                                      min: 12,
                                      max: 14,
                                    ),
                                    color: Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // authController.resendOtp(widget.email);
                                  },
                                  child: Text(
                                    "RESEND OTP",
                                    style: TextStyle(
                                      fontSize: scaleText(
                                        0.035,
                                        min: 12,
                                        max: 14,
                                      ),
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.01),

                            /// Send OTP Button
                            WideCustomButton(
                              text: 'Verify OTP',
                              onPressed: () {
                                authController.verifyOtp(
                                  widget.email,
                                  pinController.text,
                                  widget.otpVerifyType,
                                );
                              },
                            ),
                            SizedBox(height: height * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Bottom text
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Text(
                        "Your Profile helps us customize your experience",
                        style: TextStyle(
                          color: AppColors.context(context).textColor,
                          fontSize: scaleText(0.03, min: 12, max: 14),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/lockk.png',
                            height: width * 0.04,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Your data is secure and private",
                            style: TextStyle(
                              color: AppColors.context(context).textColor,
                              fontSize: scaleText(0.03, min: 12, max: 14),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
