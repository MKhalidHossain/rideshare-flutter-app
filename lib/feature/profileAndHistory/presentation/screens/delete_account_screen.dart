import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/constants/app_colors.dart';
import 'package:rideztohealth/core/validation/validators.dart';
import 'package:rideztohealth/core/widgets/app_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String? prefilledEmail;

  const DeleteAccountScreen({super.key, this.prefilledEmail});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  static const String _deleteFormUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLSc5oNpo565eiCtZxE1qMTg-IrLe7FrSJQH1ZnWPIqPaaILpuw/viewform?usp=pp_url';
  // Set this to the Google Form email field entry key to force prefilling.
  static const String _deleteFormEmailEntryKey = 'entry.1643574451';
  // Set this to the Google Form reason field entry key to force prefilling.
  static const String _deleteFormReasonEntryKey = 'entry.1317547186';

  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _reasonFocus = FocusNode();
  late final TextEditingController _emailController;
  late final TextEditingController _reasonController;

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

  Uri _buildDeleteFormUri({required String email, required String reason}) {
    if (email.isEmpty && reason.isEmpty) return Uri.parse(_deleteFormUrl);

    final base = Uri.parse(_deleteFormUrl);
    final params = Map<String, String>.from(base.queryParameters);
    if (email.isNotEmpty) {
      params['emailAddress'] = email;
    }
    params['usp'] = 'pp_url';
    if (_deleteFormEmailEntryKey.isNotEmpty) {
      params[_deleteFormEmailEntryKey] = email;
    }
    if (_deleteFormReasonEntryKey.isNotEmpty) {
      params[_deleteFormReasonEntryKey] = reason;
    }

    return base.replace(queryParameters: params);
  }

  Future<void> _openDeleteForm() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final reason = _reasonController.text.trim();
    final uri = _buildDeleteFormUri(email: email, reason: reason);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the delete request form.'),
        ),
      );
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
      body: LayoutBuilder(
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
                          'Request Account Deletion',
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
                          'You will be redirected to a Google Form to confirm '
                          'your request.',
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
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                            hintText: 'name@example.com',
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
                          validator: Validators.email,
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
                            labelText: 'Reason for Deletion',
                            labelStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                            ),
                            hintText: 'Tell us why you want to delete your account',
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
                          validator: _requiredValidator,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'If the form does not prefill your email, '
                          'please paste it manually.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openDeleteForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: AppColors.primaryColorStatic,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          child: const Text(
                              'Delete Account',
                              style: TextStyle(
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
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
