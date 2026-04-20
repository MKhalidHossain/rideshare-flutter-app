import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/profileAndHistory/controllers/profile_and_history_controller.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/get_profile_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/request_model/update_profile_request_model.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';

import '../../../../core/widgets/wide_custom_button.dart';

class EditProfile extends StatefulWidget {
  ProfileData? userProfile;

  EditProfile({super.key, required this.userProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController cityController;

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();
  File? _localImageFile;
  XFile? _pendingProfileImageFile;

  bool isEditing = false; // Track whether user is editing

  late ProfileAndHistoryController profileController;

  @override
  void initState() {
    super.initState();
    print(
      'Profile Image URL: ${widget.userProfile?.profileImage ?? 'No image URL'}',
    );
    nameController = TextEditingController(text: widget.userProfile?.fullName);
    emailController = TextEditingController(text: widget.userProfile?.email);
    phoneController = TextEditingController(
      text: widget.userProfile?.phoneNumber,
    );
    countryController = TextEditingController(
      text: widget.userProfile?.country ?? '',
    );
    cityController = TextEditingController(
      text: widget.userProfile?.city ?? '',
    );

    profileController = Get.find<ProfileAndHistoryController>();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    countryFocus.dispose();
    cityFocus.dispose();
    countryController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    try {
      setState(() {
        _localImageFile = File(picked.path);
        _pendingProfileImageFile = picked;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read selected image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileAndHistoryController>(
      builder: (profileController) {
        return profileController.isLoading
            ? _ProfileShimmerLoader()
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: BackButton(
                    color: Colors.white,
                    onPressed: () => Get.back(),
                  ),
                  title: 'My Profile'.text20white(),
                ),
                body: Stack(
                  children: [
                    // Top background image

                    // Page content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16,
                            bottom: 0,
                            left: 16,
                            right: 16,
                          ),
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(
                                        0,
                                        2,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      height: 170,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                  offset: Offset(
                                                    0,
                                                    2,
                                                  ), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child:
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(
                                                          0xffCE0000,
                                                        ).withOpacity(0.8),
                                                        // Color(0xFFCE0000),
                                                        Color(
                                                          0xff7B0100,
                                                        ).withOpacity(0.8),
                                                      ],
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ), // adjust for how round you want it
                                                    child: Builder(
                                                      builder: (context) {
                                                        if (_localImageFile !=
                                                            null) {
                                                          return Image.file(
                                                            _localImageFile!,
                                                            width: 170,
                                                            height: 170,
                                                            fit: BoxFit.cover,
                                                          );
                                                        }
                                                        final imageUrl =
                                                            widget
                                                                .userProfile
                                                                ?.profileImage;

                                                        if (imageUrl == null ||
                                                            imageUrl.isEmpty) {
                                                          // Fallback placeholder if no profile image
                                                          return Center(
                                                            child: Icon(
                                                              Icons
                                                                  .person_outline,
                                                              size: 90,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        }

                                                        return Image.network(
                                                          imageUrl,
                                                          width: 170,
                                                          height: 170,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder:
                                                              (
                                                                context,
                                                                child,
                                                                loadingProgress,
                                                              ) {
                                                                if (loadingProgress ==
                                                                    null)
                                                                  return child;

                                                                // Shimmer effect while loading
                                                                return const ShimmerSkeleton(
                                                                  child: SizedBox(
                                                                    width: 170,
                                                                    height: 170,
                                                                    child:
                                                                        ColoredBox(
                                                                      color:
                                                                          kShimmerFillColor,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) {
                                                                // Placeholder if image fails to load
                                                                return Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .person_outline,
                                                                    size: 90,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                );
                                                              },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                          ),
                                          if (isEditing)
                                            Positioned(
                                              bottom: 6,
                                              right: 6,
                                              child: Material(
                                                color: Colors.red.shade700,
                                                shape: const CircleBorder(),
                                                child: InkWell(
                                                  customBorder:
                                                      const CircleBorder(),
                                                  onTap: _pickProfileImage,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Colors.white,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.image_outlined,
                                                      size: 18,
                                                      color:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    //(

                                    //widget.userProfile.name ??77

                                    //'Mr. User Name')
                                    '${widget.userProfile?.fullName ?? 'No name'}'
                                        .text24White(),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildCustomTextField(
                                  title: 'Name',
                                  context: context,
                                  label: ' ex: Khalid Hossain',
                                  controller: nameController,
                                  icon: Icons.person,
                                  focusNode: nameFocus,

                                  isEditing: isEditing,
                                  nextFocusNode:
                                      isEditing ? countryFocus : emailFocus,
                                  validator: (value) => value!.isEmpty
                                      ? 'Name is required'
                                      : null,
                                ),
                                _buildCustomTextField(
                                  title: 'Country',
                                  context: context,
                                  label: 'Enter your country',
                                  controller: countryController,
                                  icon: Icons.flag,
                                  focusNode: countryFocus,
                                  nextFocusNode: cityFocus,
                                  isEditing: isEditing,
                                  validator: (value) => value!.isEmpty
                                      ? 'Country is required'
                                      : null,
                                ),
                                _buildCustomTextField(
                                  title: 'City',
                                  context: context,
                                  label: 'Enter your City',
                                  controller: cityController,
                                  icon: Icons.location_city,
                                  focusNode: cityFocus,
                                  nextFocusNode: phoneFocus,
                                  isEditing: isEditing,
                                  validator: (value) => value!.isEmpty
                                      ? 'City is required'
                                      : null,
                                ),
                                // Hide Email field when editing
                                if (!isEditing)
                                  _buildCustomTextField(
                                    title: 'Email',
                                    context: context,
                                    label: 'example@gmail.com',
                                    controller: emailController,
                                    icon: Icons.email,
                                    focusNode: emailFocus,
                                    nextFocusNode: phoneFocus,
                                    isEditing: isEditing,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) => value!.isEmpty
                                        ? 'Email is required'
                                        : null,
                                  ),
                                _buildCustomTextField(
                                  title: 'Phone Number',
                                  context: context,
                                  label: 'xxxxxxxxxxxx',
                                  controller: phoneController,
                                  icon: Icons.phone,
                                  focusNode: phoneFocus,
                                  nextFocusNode: null,
                                  isEditing: isEditing,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => value!.isEmpty
                                      ? 'Phone is required'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                isEditing
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: WideCustomButton(
                                              text: 'Cancel',
                                              //color: Colors.grey,
                                              onPressed: () {
                                                setState(() {
                                                  isEditing = false;
                                                  _pendingProfileImageFile =
                                                      null;
                                                  _localImageFile = null;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: WideCustomButton(
                                              text: 'Save',
                                              isLoading:
                                                  profileController.isLoading,
                                              //color: Colors.red,
                                              onPressed: () async {
                                                if (nameController
                                                        .text
                                                        .trim()
                                                        .isEmpty ||
                                                    countryController
                                                        .text
                                                        .trim()
                                                        .isEmpty ||
                                                    cityController.text
                                                        .trim()
                                                        .isEmpty) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Please fill name, country, and city.',
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                try {
                                                  if (_pendingProfileImageFile !=
                                                      null) {
                                                    await profileController
                                                        .updateProfileImage(
                                                      _pendingProfileImageFile!,
                                                    );
                                                  }

                                                  await profileController
                                                      .updateUserProfile(
                                                    UpdateProfileRequestModel(
                                                      fullName: nameController
                                                          .text
                                                          .trim(),
                                                      country: countryController
                                                          .text
                                                          .trim(),
                                                      city: cityController.text
                                                          .trim(),
                                                    ),
                                                  );
                                                  await profileController
                                                      .getProfile();

                                                  setState(() {
                                                    isEditing = false;
                                                  _pendingProfileImageFile =
                                                        null;
                                                    _localImageFile = null;
                                                    widget.userProfile =
                                                        profileController
                                                            .getProfileResponseModel
                                                            .data;
                                                    nameController.text =
                                                        widget.userProfile
                                                                ?.fullName ??
                                                            nameController.text;
                                                    emailController.text =
                                                        widget.userProfile
                                                                ?.email ??
                                                            emailController.text;
                                                    phoneController.text =
                                                        widget.userProfile
                                                                ?.phoneNumber ??
                                                            phoneController.text;
                                                    countryController.text =
                                                        widget.userProfile
                                                                ?.country ??
                                                            countryController
                                                                .text;
                                                    cityController.text =
                                                        widget.userProfile
                                                                ?.city ??
                                                            cityController.text;
                                                  });
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Could not update profile. Please try again.',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : WideCustomButton(
                                        text: 'Edit',
                                        onPressed: () {
                                          setState(() {
                                            isEditing = true;
                                          });
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
  required bool isEditing,
  TextInputType keyboardType = TextInputType.text,
  required String? Function(String?) validator,
  bool obscureText = false,
  VoidCallback? toggleObscureText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        readOnly: !isEditing,
        enableInteractiveSelection: isEditing,
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
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.grey, size: 24),
          ),
          hintText: label,
          hintStyle:  TextStyle(color: Colors.grey.withOpacity(0.7)),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: isEditing
                ? BorderSide(color: Colors.green.shade800, width: 1.5)
                : BorderSide.none,
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

class _ProfileShimmerLoader extends StatelessWidget {
  const _ProfileShimmerLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Row(
                children: const [
                  ShimmerCircle(size: 32),
                  SizedBox(width: 12),
                  ShimmerLine(width: 140, height: 18),
                  Spacer(),
                  ShimmerLine(width: 32, height: 12),
                ],
              ),
              const SizedBox(height: 20),
              const ShimmerBox(
                width: 170,
                height: 170,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              const SizedBox(height: 12),
              const ShimmerLine(width: 160, height: 18),
              const SizedBox(height: 24),
              _buildFieldShimmer(),
              _buildFieldShimmer(),
              _buildFieldShimmer(),
              _buildFieldShimmer(),
              _buildFieldShimmer(),
              const SizedBox(height: 8),
              const ShimmerBox(
                width: double.infinity,
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ShimmerLine(width: 90, height: 12),
        SizedBox(height: 8),
        ShimmerBox(
          width: double.infinity,
          height: 48,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
