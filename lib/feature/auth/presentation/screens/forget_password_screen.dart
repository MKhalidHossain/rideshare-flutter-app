import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/verify_otp_screen.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/validation/validators.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/wide_custom_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController _emailController;
  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String otpVerifyType = 'password_reset';
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // 🔥 clamp font sizes (min, calculated, max)
    double titleSize = (width * 0.06).clamp(20.0, 28.0);
    double subtitleSize = (width * 0.04).clamp(14.0, 18.0);
    double inputSize = (width * 0.04).clamp(14.0, 18.0);
    double bottomSize = (width * 0.03).clamp(12.0, 14.0);

    return GetBuilder<AuthController>(
      builder: (authController) {
        return AppScaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, // 5% of screen width
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: height * 0.6),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: height * 0.06),
                            const AppLogo(),
                            SizedBox(height: height * 0.06),

                            /// Title
                            Text(
                              'Reset password',
                              style: TextStyle(
                                color: AppColors.context(context).textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: titleSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.012),

                            Text(
                              'Enter your email to receive the OTP',
                              style: TextStyle(
                                color: const Color(0xffD1D5DB),
                                fontWeight: FontWeight.w400,
                                fontSize: subtitleSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.06),

                            /// Email Input
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    'assets/images/email.png',
                                    width: width * 0.06,
                                    height: width * 0.06,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  fontSize: inputSize,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              validator: Validators.email,
                              style: TextStyle(
                                color: AppColors.context(context).textColor,
                                fontSize: inputSize,
                                fontWeight: FontWeight.w400,
                              ),
                              autofillHints: const [AutofillHints.email],
                            ),

                            SizedBox(height: height * 0.06),

                            /// Send OTP Button
                            WideCustomButton(
                              text: 'Send OTP',
                              onPressed: () {
                                authController.forgetPassword(
                                  _emailController.text,
                                  otpVerifyType,
                                );
                                // Get.to(
                                //   () => VerifyOtpScreen(
                                //     email: _emailController.text,
                                //   ),
                                // );
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your Profile helps us customize your experience",
                        style: TextStyle(
                          color: AppColors.context(context).textColor,
                          fontSize: bottomSize,
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
                          SizedBox(width: 4),
                          Text(
                            "Your data is secure and private",
                            style: TextStyle(
                              color: AppColors.context(context).textColor,
                              fontSize: bottomSize,
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
