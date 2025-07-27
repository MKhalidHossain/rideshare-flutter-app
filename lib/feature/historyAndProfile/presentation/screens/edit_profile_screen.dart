import 'package:flutter/material.dart';

import 'package:rideztohealth/core/extensions/text_extensions.dart';
import '../../../../core/widgets/wide_custom_button.dart';

class EditProfile extends StatefulWidget {
  // final UserforProfile userProfile;

  const EditProfile({super.key});

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: 'Alex Johnson');
    emailController = TextEditingController(text: 'example@gmail.com');
    phoneController = TextEditingController(text: 'xxxxxxxxxxxx');
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
    return Scaffold(
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
                            offset: Offset(0, 2), // changes position of shadow
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
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffCE0000).withOpacity(0.8),
                                        // Color(0xFFCE0000),
                                        Color(0xff7B0100).withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/images/user6.png',
                                      fit: BoxFit.cover,
                                      width: 170,
                                      height: 170,
                                    ),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 10),
                          //(

                          //widget.userProfile.name ??

                          //'Mr. User Name')
                          'Mr. User Name'.text24White(),
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
                        nextFocusNode: isEditing ? phoneFocus : emailFocus,
                        validator: (value) =>
                            value!.isEmpty ? 'Name is required' : null,
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
                          validator: (value) =>
                              value!.isEmpty ? 'Email is required' : null,
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
                        validator: (value) =>
                            value!.isEmpty ? 'Phone is required' : null,
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
