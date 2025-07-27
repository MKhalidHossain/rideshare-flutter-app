import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/core/common/button/button_widget.dart';

import '../../../../core/constants/app_colors.dart';

class UploadProfileScreen extends StatefulWidget {
  const UploadProfileScreen({super.key});

  @override
  State<UploadProfileScreen> createState() => _UploadProfileScreenState();
}

class _UploadProfileScreenState extends State<UploadProfileScreen> {
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isImageSelected = _profileImage != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Upload Profile",
          style: TextStyle(
            color: AppColors.primaryTextBlack,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Text(
              "To create your new account, provide one of your photos.",
              style: TextStyle(
                color: AppColors.secondayText,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 64),
            const SizedBox(height: 64),

            /// Profile Circle
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.context(context).primaryColor,
                  width: 9,
                ),
              ),
              padding: EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child:
                    _profileImage == null
                        ? Icon(Icons.person, size: 270, color: Colors.grey)
                        : null,
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                const SizedBox(width: 32),
                _buildIconButton(
                  icon: Icons.photo,
                  label: "Photos",
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),

            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Optional: Allow skip
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.context(context).primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      "Skip",
                      style: TextStyle(color: AppColors.context(context).primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: context.primaryButton(
                    onPressed: () {
                      if (isImageSelected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Profile uploaded"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    text: "Continue",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.secondayText, size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: AppColors.context(context).primaryColor)),
        ],
      ),
    );
  }
}
