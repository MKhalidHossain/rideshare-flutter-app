import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/constants/app_colors.dart';
import 'package:rideztohealth/core/validation/validators.dart';
import 'package:rideztohealth/core/widgets/app_scaffold.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/feature/profileAndHistory/controllers/profile_and_history_controller.dart';
import 'package:rideztohealth/helpers/custom_snackbar.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String? prefilledEmail;

  const DeleteAccountScreen({super.key, this.prefilledEmail});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _reasonFocus = FocusNode();
  late final TextEditingController _emailController;
  late final TextEditingController _reasonController;
  final ProfileAndHistoryController _profileController =
      Get.find<ProfileAndHistoryController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    _emailController =
        TextEditingController(text: widget.prefilledEmail ?? '');
    _reasonController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _reasonController.dispose();
    _emailFocus.dispose();
    _reasonFocus.dispose();
    super.dispose();
  }

  Future<void> _submitDeleteRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final response = await _profileController.deleteAccount(email);

    if (response == null) {
      showCustomSnackBar(
        'Unable to delete account right now.',
        isError: true,
      );
      return;
    }

    if (response.statusCode == 200) {
      await _authController.authServiceInterface.clearUserCredentials();
      showCustomSnackBar(
        response.body is Map && response.body['message'] != null
            ? response.body['message'].toString()
            : 'Account deleted successfully.',
      );
      Get.offAll(() => const UserLoginScreen());
      return;
    }

    showCustomSnackBar(
      response.body is Map && response.body['message'] != null
          ? response.body['message'].toString()
          : 'Failed to delete account. Please try again.',
      isError: true,
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB10706),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Yes, Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _submitDeleteRequest();
    } else if (confirmed == false) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white.withOpacity(0.05);
    final borderColor = Colors.white.withOpacity(0.08);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: GetBuilder<ProfileAndHistoryController>(
        builder: (controller) {
          final isSubmitting = controller.deleteAccountLoading;
          return LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth =
                  constraints.maxWidth < 560 ? constraints.maxWidth : 560.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Enter the email associated with your account. '
                              'We will process your deletion request.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Email or Phone',
                                labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                hintText: 'name@example.com or +8801XXXXXXXXX',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.04),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              validator: _emailOrPhoneValidator,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _reasonController,
                              focusNode: _reasonFocus,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Reason for Deletion (Optional)',
                                labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                hintText:
                                    'Tell us why you want to delete your account',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.04),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    isSubmitting ? null : _showDeleteConfirmation,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor:
                                      AppColors.primaryColorStatic,
                                  disabledBackgroundColor:
                                      AppColors.primaryColorStatic
                                          .withOpacity(0.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  isSubmitting
                                      ? 'Processing...'
                                      : 'Delete Account',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String? _emailOrPhoneValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email or phone is required';
    }

    final isEmail = trimmed.contains('@');
    if (isEmail) {
      return Validators.email(trimmed);
    }

    final digitsOnly = trimmed.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
