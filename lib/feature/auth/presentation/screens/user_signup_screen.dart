import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/validation/validators.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';
import 'user_login_screen.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => UserSignupScreenState();
}

class UserSignupScreenState extends State<UserSignupScreen> {
  late AuthController authController;
  bool value = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  static const String _privacyPolicyUrl =
      'https://privacy.rideztransportation.com';
  static const String _termsOfServiceUrl =
      'https://privacy.rideztransportation.com/privacy.html';
  late final TapGestureRecognizer _privacyPolicyRecognizer;
  late final TapGestureRecognizer _termsOfServiceRecognizer;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    authController = Get.find<AuthController>();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = _openPrivacyPolicy;
    _termsOfServiceRecognizer = TapGestureRecognizer()
      ..onTap = _openTermsOfService;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    _privacyPolicyRecognizer.dispose();
    _termsOfServiceRecognizer.dispose();
    super.dispose();
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(_privacyPolicyUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open privacy policy.')),
      );
    }
  }

  Future<void> _openTermsOfService() async {
    final uri = Uri.parse(_termsOfServiceUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open terms of service.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const String otpVerifyType = "email_verification";
    const String userRole = "customer";

    return GetBuilder<AuthController>(
      builder: (authController) {
        return AppScaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: size.height),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 32),
                              Center(
                                child: Text(
                                  'Create Your Account',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.context(context).textColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildCustomTextField(
                                title: 'Name',
                                context: context,
                                label: 'Enter your Full Name',
                                controller: _nameController,
                                icon: Icons.person_outline,
                                focusNode: _nameFocus,
                                nextFocusNode: _emailFocus,
                                validator: Validators.name,
                              ),

                              _buildCustomTextField(
                                title: 'Email',
                                context: context,
                                label: 'Enter your Email',
                                controller: _emailController,
                                icon: Icons.email_outlined,
                                focusNode: _emailFocus,
                                nextFocusNode: _phoneFocus,
                                validator: Validators.email,
                              ),

                              _buildCustomTextField(
                                title: 'Phone Number',
                                context: context,
                                label: 'Enter your Phone Number (Optional)',
                                controller: _phoneController,
                                icon: Icons.phone_outlined,
                                focusNode: _phoneFocus,
                                nextFocusNode: _passwordFocus,
                                validator: Validators.phone,
                              ),

                              _buildCustomTextField(
                                title: 'Password',
                                context: context,
                                label: 'Create a Password',
                                controller: _passwordController,
                                icon: Icons.lock_outline,
                                focusNode: _passwordFocus,
                                nextFocusNode: _confirmPasswordFocus,
                                validator: Validators.password,
                                obscureText: _obscurePassword,
                                toggleObscureText: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),

                              _buildCustomTextField(
                                title: 'Confirm Password',
                                context: context,
                                label: 'Confirm your Password',
                                controller: _confirmPasswordController,
                                icon: Icons.lock_outline,
                                focusNode: _confirmPasswordFocus,
                                nextFocusNode: _nameFocus,
                                validator: Validators.password,
                                obscureText: _obscureConfirmPassword,
                                toggleObscureText: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),

                              Row(
                                children: [
                                  Checkbox(
                                    value: value,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        value = newValue ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: RichText(
                                      maxLines: 3,
                                      text: TextSpan(
                                        text:
                                            'By Registration, You agree to the',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: ' term of services ',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer:
                                                _termsOfServiceRecognizer,
                                          ),
                                          const TextSpan(
                                            text: ' and ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' privacy policy. ',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer:
                                                _privacyPolicyRecognizer,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              WideCustomButton(
                                text: 'Sign Up',
                                isLoading: authController.isLoading,
                                onPressed: () {
                                  final phoneNumber = _phoneController.text
                                      .trim();
                                  authController.register(
                                    otpVerifyType,
                                    _nameController.text.trim(),
                                    _emailController.text.trim().toLowerCase(),
                                    phoneNumber.isEmpty ? null : phoneNumber,
                                    _passwordController.text.trim(),
                                    userRole,
                                  );
                                },
                              ),

                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: AppColors.context(
                                          context,
                                        ).popupBackgroundColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(UserLoginScreen());
                                      },
                                      child: Text(
                                        'Sign in',
                                        style: TextStyle(
                                          color: AppColors.context(
                                            context,
                                          ).primaryColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Your Profile helps us customize your experience",
                                      style: TextStyle(
                                        color: AppColors.context(
                                          context,
                                        ).textColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/lockk.png',
                                          height: 16,
                                        ),
                                        Text(
                                          "Your data is secure and private",
                                          style: TextStyle(
                                            color: AppColors.context(
                                              context,
                                            ).textColor,
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
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
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

Widget _buildCustomTextField({
  required String title,
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required FocusNode focusNode,
  required FocusNode? nextFocusNode,
  TextInputType keyboardType = TextInputType.text,
  required String? Function(String?) validator,
  bool obscureText = false,
  VoidCallback? toggleObscureText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        textInputAction: nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        cursorColor: Colors.grey,
        style: TextStyle(
          color: AppColors.context(context).textColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.grey, size: 24),
          ),
          suffixIcon: obscureText && toggleObscureText != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggleObscureText,
                )
              : null,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green[800]!, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}

// Widget _buildCustomTextField({
//   required String title,
//   required BuildContext context,
//   required String label,
//   required TextEditingController controller,
//   required IconData icon,
//   required FocusNode focusNode,
//   TextInputType keyboardType = TextInputType.text,
//   required String? Function(String?) validator,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       RichText(
//         text: TextSpan(
//           text: title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//           children: const [
//             TextSpan(
//               text: ' *',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(height: 8),
//       TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: keyboardType,
//         validator: validator,
//         cursorColor: Colors.grey,
//         decoration: InputDecoration(
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Icon(icon, color: Colors.grey, size: 24),

//             // Image.asset(
//             //   iconPath,
//             //   fit: BoxFit.contain,
//             //   width: 24,
//             //   height: 24,
//             //   color: Colors.grey,
//             // ),
//           ),
//           hintText: label,
//           hintStyle: TextStyle(color: Colors.grey),
//           filled: true,
//           fillColor: Colors.grey.withOpacity(0.1),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(focusNode),
//         style: TextStyle(
//           color: AppColors.context(context).textColor,
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       const SizedBox(height: 24),
//     ],
//   );
// }
