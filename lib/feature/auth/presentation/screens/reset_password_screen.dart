import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/wide_custom_button.dart';

class ResetChangePassword extends StatefulWidget {
  final String userEmail;

  const ResetChangePassword({super.key, required this.userEmail});

  @override
  State<ResetChangePassword> createState() => _RestartPasswordState();
}

class _RestartPasswordState extends State<ResetChangePassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool get _passwordsMatch =>
      _newPasswordController.text.isNotEmpty &&
      _repeatPasswordController.text.isNotEmpty &&
      _newPasswordController.text == _repeatPasswordController.text;

  void _updateState() => setState(() {});

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_updateState);
    _repeatPasswordController.addListener(_updateState);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_updateState);
    _repeatPasswordController.removeListener(_updateState);
    _newPasswordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                            SizedBox(height: height * 0.05),
                            const AppLogo(),
                            SizedBox(height: height * 0.05),

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
                              'Set New Password',
                              style: TextStyle(
                                color: const Color(0xffD1D5DB),
                                fontWeight: FontWeight.w400,
                                fontSize: subtitleSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.05),

                            /// Email Input
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _newPasswordController,

                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/images/password.png',
                                          width: width * 0.06,
                                          height: width * 0.06,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      hintText: 'New Password',
                                      hintStyle: TextStyle(
                                        fontSize: inputSize,
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    // validator: Validators.password(_newPasswordController.text),
                                    style: TextStyle(
                                      color: AppColors.context(
                                        context,
                                      ).textColor,
                                      fontSize: inputSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    autofillHints: const [AutofillHints.email],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  TextFormField(
                                    controller: _repeatPasswordController,

                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/images/password.png',
                                          width: width * 0.06,
                                          height: width * 0.06,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      hintText: 'Confirm Password',
                                      hintStyle: TextStyle(
                                        fontSize: inputSize,
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    // validator: Validators.email,
                                    style: TextStyle(
                                      color: AppColors.context(
                                        context,
                                      ).textColor,
                                      fontSize: inputSize,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    autofillHints: const [AutofillHints.email],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: height * 0.05),

                            /// Send OTP Button
                            WideCustomButton(
                              text: 'Continue',
                              isLoading: authController.isLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (!_passwordsMatch) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Passwords do not match"),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  } else {
                                    print("EMAIL: ${widget.userEmail}");
                                    print(
                                      "PASS: ${_newPasswordController.text}",
                                    );
                                    print(
                                      "CONFIRM PASS: ${_repeatPasswordController.text}",
                                    );

                                    final String pass =
                                        _newPasswordController.text;
                                    authController.resetPassword(
                                      widget.userEmail,
                                      pass,
                                    );
                                  }

                                  // ScaffoldMessenger.of(
                                  //   context,
                                  // ).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text(
                                  //       "Password changed successfully",
                                  //     ),
                                  //     backgroundColor: Colors.green,
                                  //     behavior: SnackBarBehavior.floating,
                                  //   ),
                                  // );
                                  _newPasswordController.clear();
                                  _repeatPasswordController.clear();
                                }
                              },
                            ),
                            SizedBox(height: height * 0.03),
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

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AuthController>(
//       builder: (authController) {
//         return Scaffold(
//           backgroundColor: AppColors.background,
//           appBar: AppBar(
//             backgroundColor: AppColors.background,
//             leading: const BackButton(color: AppColors.primaryTextBlack),
//             title: const Text(
//               "Create new Password",
//               style: TextStyle(color: Colors.black, fontSize: 24),
//             ),
//           ),
//           body: SafeArea(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: constraints.maxHeight,
//                     ),
//                     child: IntrinsicHeight(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 32,
//                         ),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 32),

//                               /// New Password
//                               TextFormField(
//                                 controller: _newPasswordController,
//                                 obscureText: !_showNewPassword,
//                                 style: TextStyle(color: AppColors.secondayText),
//                                 decoration: _buildInputDecoration(
//                                   hintText: "New Password",
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showNewPassword
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: AppColors.secondayText,
//                                     ),
//                                     onPressed: () {
//                                       setState(
//                                         () => _showNewPassword =
//                                             !_showNewPassword,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter a password';
//                                   } else if (value.length < 6) {
//                                     return 'Password must be at least 6 characters';
//                                   }
//                                   return null;
//                                 },
//                               ),

//                               const SizedBox(height: 16),

//                               /// Repeat Password
//                               TextFormField(
//                                 controller: _repeatPasswordController,
//                                 obscureText: !_showRepeatPassword,
//                                 style: TextStyle(color: AppColors.secondayText),
//                                 decoration: _buildInputDecoration(
//                                   hintText: "Repeat New Password",
//                                   suffixIcon: IconButton(
//                                     icon: Icon(
//                                       _showRepeatPassword
//                                           ? Icons.visibility_off
//                                           : Icons.visibility,
//                                       color: AppColors.secondayText,
//                                     ),
//                                     onPressed: () {
//                                       setState(
//                                         () => _showRepeatPassword =
//                                             !_showRepeatPassword,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please repeat your password';
//                                   } else if (value !=
//                                       _newPasswordController.text) {
//                                     return 'Passwords do not match';
//                                   }
//                                   return null;
//                                 },
//                               ),

//                               const SizedBox(height: 32),

//                               /// Continue Button
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 0,
//                                   vertical: 16,
//                                 ),
//                                 child: context.primaryButton(
//                                   onPressed: () {
//                                     if (_formKey.currentState!.validate()) {
//                                       if (!_passwordsMatch) {
//                                         ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               "Passwords do not match",
//                                             ),
//                                             backgroundColor: Colors.red,
//                                             behavior: SnackBarBehavior.floating,
//                                           ),
//                                         );
//                                         return;
//                                       } else {
//                                         // print("EMAIL: ${widget.userEmail}");
//                                         // print(
//                                         //   "PASS: ${_newPasswordController.text}",
//                                         // );
//                                         // print(
//                                         //   "CONFIRM PASS: ${_repeatPasswordController.text}",
//                                         // );

//                                         final String pass =
//                                             _newPasswordController.text;
//                                         final String repPass =
//                                             _repeatPasswordController.text;
//                                       }

//                                       // ScaffoldMessenger.of(
//                                       //   context,
//                                       // ).showSnackBar(
//                                       //   const SnackBar(
//                                       //     content: Text(
//                                       //       "Password changed successfully",
//                                       //     ),
//                                       //     backgroundColor: Colors.green,
//                                       //     behavior: SnackBarBehavior.floating,
//                                       //   ),
//                                       // );
//                                       // _newPasswordController.clear();
//                                       // _repeatPasswordController.clear();
//                                     }
//                                   },
//                                   text: "Continue",
//                                   backgroundColor: _passwordsMatch
//                                       ? AppColors.primaryColor
//                                       : AppColors.secondaryColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
