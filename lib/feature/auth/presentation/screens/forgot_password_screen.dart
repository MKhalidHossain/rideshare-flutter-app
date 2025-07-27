import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/verify_otp_screen.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/validation/validators.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/wide_custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  // final String emailFocus;

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  final FocusNode _emailFocus = FocusNode();

  @override
  void initState() {
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will ensure that the focus is requested after the widget is built
      if (_emailFocus.hasFocus) {
        _emailFocus.requestFocus();
      }
    });
    // _emailFocus.requestFocus();
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
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // 🔥 Center vertically
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        AppLogo(),
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            'Reset password',

                            style: TextStyle(
                              color: AppColors.context(context).textColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Enter your email to receive the OTP',
                            style: TextStyle(
                              color: Color(0xffD1D5DB),
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 12),

                        /// Email
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/images/email.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                            hint: Text(
                              'Enter your email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFFFFF).withOpacity(0.3),
                              ),
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                          textInputAction: TextInputAction.done,
                          validator: Validators.email,
                          style: TextStyle(
                            color: AppColors.context(context).textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          autofillHints: const [AutofillHints.email],
                        ),

                        const SizedBox(height: 12),

                        /// Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(ForgotPasswordScreen());
                            },
                            child: 'Forgot Password ?'.text14Blue(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// Login button
                        WideCustomButton(
                          text: 'Send OTP',
                          onPressed: () {
                            //Get.to(() => BottomNavBar());
                            onPressed:
                            () {
                              Get.to(
                                () => VerifyOtpScreen(
                                  email: _emailController.text,
                                ),
                              );
                              // Get.to(
                              //   () => VerifyOtpScreen(
                              //     email: _emailController.text,
                              //   ),
                              // );
                            };
                          },
                        ),
                        // context.primaryButton(
                        //   onPressed: () {
                        //     String email = _emailController.text;
                        //     String password = _passwordController.text;
                        //     if (email.isEmpty) {
                        //       showCustomSnackBar('email is required'.tr);
                        //     } else if (password.isEmpty) {
                        //       showCustomSnackBar('password_is_required'.tr);
                        //     } else if (password.length < 5) {
                        //       showCustomSnackBar(
                        //         'minimum password length is 8',
                        //       );
                        //     } else {
                        //       // authController.login(email, password);
                        //     }

                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(
                        //     //     builder: (context) => BottomNavigationBar(),
                        //     //   ),
                        //     // );
                        //   },
                        //   text: "Login",
                        // ),
                        // const SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     'New To our Platform?'.text12White(),
                        //     TextButton(
                        //       child: Text(
                        //         "Sign Up Here",
                        //         style: TextStyle(
                        //           color: Colors.red,
                        //           fontSize: 12,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       onPressed: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => UserSignupScreen(),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 16),

                        /// Google
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton.icon(
                        //     onPressed: () {},
                        //     icon: Image.asset(
                        //       'assets/images/google.png',
                        //       height: 24,
                        //       width: 24,
                        //     ),
                        //     label: Text(
                        //       "Continue With Google",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.context(
                        //         context,
                        //       ).backgroundColor,
                        //       foregroundColor: AppColors.context(
                        //         context,
                        //       ).popupBackgroundColor,
                        //       elevation: 1,
                        //       padding: EdgeInsets.symmetric(vertical: 16),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //         side: BorderSide(color: Colors.grey, width: 1),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 12),

                        // /// Apple
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: ElevatedButton.icon(
                        //     onPressed: () {},
                        //     icon: Image.asset(
                        //       'assets/images/apple.png',
                        //       height: 24,
                        //       width: 24,
                        //     ),
                        //     label: Text(
                        //       "Continue With Apple",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: AppColors.context(
                        //         context,
                        //       ).backgroundColor,
                        //       foregroundColor: AppColors.context(
                        //         context,
                        //       ).textColor,
                        //       elevation: 1,
                        //       padding: EdgeInsets.symmetric(vertical: 16),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //         side: BorderSide(color: Colors.grey, width: 1),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Profile helps us customize your experience",
                  style: TextStyle(
                    color: AppColors.context(context).textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/lockk.png', height: 16),
                    Text(
                      "Your data is secure and private",
                      style: TextStyle(
                        color: AppColors.context(context).textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
