import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/historyAndProfile/presentation/screens/edit_profile_screen.dart';

import '../../../../core/constants/app_colors.dart';
import 'notifications_screen.dart';
import 'terms_and_condition.dart';
import 'wallet_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    //Get.find<ProfileController>().getUserById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: 'My Profile'.text20white(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffCE0000).withOpacity(0.8),
                            // Color(0xFFCE0000),
                            Color(0xff7B0100).withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: ClipOval(
                        child:
                            Image.asset('assets/images/user5.png') ??
                            Image.network(
                              '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                      ),
                    ),
                    SizedBox(width: 12),
                    'John Doe'.text22White(),
                    SizedBox(height: 4),
                    Spacer(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    //SizedBox(height: 12),
                    _buildMenuItem(
                      Icons.person_outline,
                      "Profile",
                      "Customize your profile",
                      onTap: () {
                        Get.to(() => EditProfile());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.wallet_outlined,
                      "Wallet",
                      "Term of services",
                      onTap: () {
                        Get.to(() => WalletScreen());
                      },
                    ),

                    _divider(),
                    _buildMenuItem(
                      Icons.notifications_outlined,
                      "Manage Notifications",
                      "Customize alerts",
                      onTap: () {
                        Get.to(NotificationsScreen());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.help_outline,
                      "Terms & Conditions",
                      "Terms & Services",
                      onTap: () {
                        Get.to(TermsAndCondition());
                      },
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.shield_outlined,
                      "Privacy policy",
                      'Privacy policy',
                      onTap: () {},
                    ),
                    _divider(),
                    _buildMenuItem(
                      Icons.logout,
                      "Log Out",
                      'Sign out of your account',
                      color: Color(0xffCE0000).withOpacity(0.8),
                      onTap: () {},
                    ),
                    _divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    Color color = Colors.black54,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white10,
      margin: const EdgeInsets.all(1),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xffD8D8D8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color == Color(0xffCE0000).withOpacity(0.8)
                ? Color(0xffCE0000).withOpacity(0.8)
                : Colors.white,
            fontSize: 16,
            fontFamily: 'outfit',
            fontWeight: FontWeight.bold,
          ),
        ),

        //title: title.text16White(),
        subtitle: subtitle.text12White(),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.context(context).iconColor,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _divider({Color color = const Color(0xffD8D8D8)}) {
    return Divider(
      height: 1,
      indent: 5,
      endIndent: 5,
      thickness: 0.1,
      color: color,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:rideztohealth/core/extensions/text_extensions.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     //Get.find<ProfileController>().getUserById();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     // final String today = DateFormat('d MMMM').format(DateTime.now());

//     //     if (profileController
//     //         .getUserByIdResponseModel
//     //         .userforProfile
//     //         .isBlank!) {
//     //       print('task is empty');
//     //       return Container(
//     //         height: size.height * 0.8,
//     //         width: size.width,
//     //         child: const Center(child: Text('No Task Found')),
//     //       );
//     //     }
//     //     if (profileController.getUserByIdResponseModel == null) {
//     //       print('TAsk is null');
//     //       return Container(
//     //         height: size.height * 0.8,
//     //         width: size.width,
//     //         child: const Center(child: Text('No Task Found')),
//     //       );
//     //     }
//     // return !profileController.getUserByIdisLoading
//     //     ?

//     return ColoredBox(
//       color: Color(0xFF438B92),
//       child: SafeArea(
//         child: Scaffold(
//           //backgroundColor: Color(0xffB0E0CF), // light gray-blue background
//           body: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // App bar title
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 16),
//                   child: 'My Profile'.text20Black(),
//                 ),
//               ),

//               // Profile Section
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.grey[200],
//                       child: ClipOval(
//                         child: Image.network(
//                           // profileController
//                           //         .getUserByIdResponseModel
//                           //         .userforProfile
//                           //         ?.avatar ??
//                           '',
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Center(
//                               child: Icon(
//                                 Icons.person_outline,
//                                 size: 30,
//                                 color: Colors.grey,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     // CircleAvatar(
//                     //   radius: 30,
//                     //   backgroundImage: NetworkImage(
//                     //     profileController
//                     //         .getUserByIdResponseModel
//                     //         .user!
//                     //         .avatar
//                     //         .toString(),
//                     //   ),
//                     //   // AssetImage(
//                     //   //   'assets/images/person.png',
//                     //   // ), // Your profile image
//                     // ),
//                     SizedBox(width: 12),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // (

//                         //   profileController
//                         //         .getUserByIdResponseModel
//                         //         .userforProfile!
//                         //         .name!
//                         //         )
//                         'John Doe'.text22White(),
//                         SizedBox(height: 4),
//                       ],
//                     ),
//                     Spacer(),
//                     // InkWell(
//                     //   onTap: () {
//                     //     // final profileUser =
//                     //     //     profileController
//                     //     //         .getUserByIdResponseModel
//                     //     //         .userforProfile;
//                     //     // if (profileUser != null) {
//                     //     //   Get.to(
//                     //     //     EditProfile(userProfile: profileUser),
//                     //     //   );
//                     //     // } else {
//                     //     //   Get.snackbar(
//                     //     //     'Error',
//                     //     //     'User data not loaded yet',
//                     //     //   );
//                     //     // }
//                     //   },
//                     //   child: Image.asset(
//                     //     'assets/icons/edit.png',
//                     //     height: 70,
//                     //     width: 70,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),

//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView(
//                     children: [
//                       SizedBox(height: 30),
//                       _buildMenuItem(
//                         Icons.info_outline,
//                         "About App",
//                         onTap: () {
//                           //Get.to(AboutAppScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.privacy_tip_outlined,
//                         "Privacy Policy",
//                         onTap: () {
//                           //Get.to(PrivacyPolicyScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.article_outlined,
//                         "Term & Condition",
//                         onTap: () {
//                           //Get.to(TearmAndConditonScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.lock_outline,
//                         "Change Password",
//                         onTap: () {
//                           // Get.to(ChangePasswordScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.notifications_outlined,
//                         "Notification",
//                         onTap: () {
//                           // Get.to(NotificationScreen());
//                         },
//                       ),
//                       _divider(),
//                       _buildMenuItem(
//                         Icons.logout,
//                         "Log Out",
//                         color: Colors.red,
//                         onTap: () {
//                           //Get.to(SignInScreen());
//                         },
//                       ),
//                       _divider(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     // : Container(child: Center(child: CircularProgressIndicator()));
//   }

//   Widget _buildMenuItem(
//     IconData icon,
//     String title, {
//     Color color = const Color(0xFF438B92),
//     required VoidCallback onTap,

//     //VoidCallback   onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style: TextStyle(color: color, fontSize: 16, fontFamily: 'outfit'),
//       ),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
//       onTap: onTap, // Handle navigation here
//     );
//   }

//   Widget _divider({Color color = const Color(0xFF438B92)}) {
//     return Divider(
//       height: 1,
//       indent: 20,
//       endIndent: 20,
//       thickness: 0.5,
//       color: color,
//     );
//   }
// }
