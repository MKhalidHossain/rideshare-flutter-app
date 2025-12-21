import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/profileAndHistory/controllers/profile_and_history_controller.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/get_profile_response_model.dart';
import 'package:shimmer/shimmer.dart';
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

  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

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
    super.dispose();
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
                  leading: BackButton(color: Colors.white),
                  title: 'My Profile'.text20white(),
                ),
                //backgroundColor: Color(0xffB0E0CF), // light gray-blue background
                body: Stack(
                  children: [
                    // Top background image

                    // Page content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // App bar title
                        // Center(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 16),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         IconButton(
                        //           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                        //           onPressed: () {
                        //             Navigator.pop(context);
                        //           },
                        //         ),
                        //         'My Profile'.text20Black(),
                        //         Text('          '),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Profile Section
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
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
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
                                      child:
                                          // widget.userProfile.avatar != null &&
                                          //         widget
                                          //             .userProfile
                                          //             .avatar!
                                          //             .isNotEmpty
                                          // ? Image.network(
                                          //   widget.userProfile.avatar!,
                                          //   width: 170,
                                          //   height: 170,
                                          //   fit: BoxFit.cover,
                                          //   errorBuilder:
                                          //       (context, error, stackTrace) =>
                                          //           Image.asset(
                                          //             'assets/images/person.png',
                                          //             width: 170,
                                          //             height: 170,
                                          //             fit: BoxFit.cover,
                                          //           ),
                                          // )
                                          //:
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                              borderRadius: BorderRadius.circular(
                                                16,
                                              ), // adjust for how round you want it
                                              child: Builder(
                                                builder: (context) {
                                                  final imageUrl = widget
                                                      .userProfile
                                                      ?.profileImage;

                                                  if (imageUrl == null ||
                                                      imageUrl.isEmpty) {
                                                    // Fallback placeholder if no profile image
                                                    return Center(
                                                      child: Icon(
                                                        Icons.person_outline,
                                                        size: 90,
                                                        color: Colors.grey,
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
                                                          return Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey
                                                                .shade300,
                                                            highlightColor:
                                                                Colors
                                                                    .grey
                                                                    .shade100,
                                                            child: Container(
                                                              width: 170,
                                                              height: 170,
                                                              color:
                                                                  Colors.white,
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
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                  );
                                                },
                                              ),
                                            ),
                                            // ClipRRect(
                                            //   borderRadius: BorderRadius.circular(16),
                                            //   child: Image.asset(
                                            //     'assets/images/user6.png',
                                            //     fit: BoxFit.cover,
                                            //     width: 170,
                                            //     height: 170,
                                            //   ),
                                            // ),
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

                              Positioned(
                                top: 120,
                                bottom: 0,
                                left: 170,

                                child: isEditing
                                    ? GestureDetector(
                                        onTap: () {},
                                        child: Image.asset(
                                          'assets/icons/edit.png',
                                          // fit: BoxFit.fitWidth,
                                          height: 35,
                                          width: 35,
                                        ),
                                      )
                                    : Container(),
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
                                  label: 'Alex Johnson',
                                  controller: nameController,
                                  icon: Icons.person,
                                  focusNode: nameFocus,

                                  isEditing: isEditing,
                                  nextFocusNode: isEditing
                                      ? phoneFocus
                                      : emailFocus,
                                  validator: (value) => value!.isEmpty
                                      ? 'Name is required'
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
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: WideCustomButton(
                                              text: 'Save',
                                              //color: Colors.red,
                                              onPressed: () {
                                                // Handle save logic
                                                setState(() {
                                                  isEditing = false;
                                                  if (nameController
                                                          .text
                                                          .isNotEmpty &&
                                                      widget
                                                              .userProfile
                                                              ?.fullName ==
                                                          nameController.text) {
                                                    profileController
                                                        .updateProfile(
                                                          nameController.text,
                                                          phoneController.text,
                                                        );
                                                  }
                                                });
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
          hintStyle: const TextStyle(color: Colors.grey),
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
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image shimmer
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),

            // Name shimmer
            Container(height: 18, width: 120, color: Colors.white),
            const SizedBox(height: 8),

            // Email shimmer
            Container(height: 14, width: 180, color: Colors.white),
            const SizedBox(height: 24),

            // Address shimmer
            Row(
              children: [
                Container(height: 20, width: 20, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Container(height: 14, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),

            // Button shimmer
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
