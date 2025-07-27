// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iwalker/core/themes/text_extensions.dart';
// import 'package:iwalker/feature/auth/presentation/screens/sign_in_screen.dart';
// import 'package:iwalker/feature/others/presentation/screens/about_app_screen.dart';
// import 'package:iwalker/feature/others/presentation/screens/tearm_and_conditon_screen.dart';
// import 'package:iwalker/feature/profile/controllers/profile_controller.dart';
// import 'package:iwalker/feature/profile/presentation/screens/edit_profile_screen.dart';
// import 'package:intl/intl.dart';
// import '../../../auth/presentation/screens/change_password_screen.dart';
// import '../../../others/presentation/screens/notification_screen.dart';
// import '../../../others/presentation/screens/privacy_policy_screen.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   //late GetUserByIdResponseModel getUserByIdResponseModel;

//   @override
//   void initState() {
//     Get.find<ProfileController>().getUserById();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final String today = DateFormat('d MMMM').format(DateTime.now());
//     return GetBuilder<ProfileController>(
//       builder: (profileController) {
//         if (profileController
//             .getUserByIdResponseModel
//             .userforProfile
//             .isBlank!) {
//           print('task is empty');
//           return Container(
//             height: size.height * 0.8,
//             width: size.width,
//             child: const Center(child: Text('No Task Found')),
//           );
//         }
//         if (profileController.getUserByIdResponseModel == null) {
//           print('TAsk is null');
//           return Container(
//             height: size.height * 0.8,
//             width: size.width,
//             child: const Center(child: Text('No Task Found')),
//           );
//         }
//         return !profileController.getUserByIdisLoading
//             ? ColoredBox(
//               color: Color(0xFF438B92),
//               child: SafeArea(
//                 child: Scaffold(
//                   //backgroundColor: Color(0xffB0E0CF), // light gray-blue background
//                   body: Stack(
//                     children: [
//                       // Top background image
//                       Positioned(
//                         top: 0,
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.1),
//                                 spreadRadius: 2,
//                                 blurRadius: 4,
//                                 offset: Offset(0.0, 25.0),
//                               ),
//                             ],
//                           ),
//                           child: Image.asset(
//                             'assets/images/bg.png', // path to your image
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: 145, // adjust height as needed
//                           ),
//                         ),
//                       ),

//                       // Page content
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // App bar title
//                           Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 16),
//                               child: 'My Profile'.text20Black(),
//                             ),
//                           ),

//                           // Profile Section
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 30,
//                                   backgroundColor: Colors.grey[200],
//                                   child: ClipOval(
//                                     child: Image.network(
//                                       profileController
//                                               .getUserByIdResponseModel
//                                               .userforProfile
//                                               ?.avatar ??
//                                           '',
//                                       width: 60,
//                                       height: 60,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (
//                                         context,
//                                         error,
//                                         stackTrace,
//                                       ) {
//                                         return Center(
//                                           child: Icon(
//                                             Icons.person_outline,
//                                             size: 30,
//                                             color: Colors.grey,
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 // CircleAvatar(
//                                 //   radius: 30,
//                                 //   backgroundImage: NetworkImage(
//                                 //     profileController
//                                 //         .getUserByIdResponseModel
//                                 //         .user!
//                                 //         .avatar
//                                 //         .toString(),
//                                 //   ),
//                                 //   // AssetImage(
//                                 //   //   'assets/images/person.png',
//                                 //   // ), // Your profile image
//                                 // ),
//                                 SizedBox(width: 12),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     (profileController
//                                             .getUserByIdResponseModel
//                                             .userforProfile!
//                                             .name!)
//                                         .text24Black(),
//                                     SizedBox(height: 4),
//                                     "Today, $today".text16Grey(),
//                                   ],
//                                 ),
//                                 Spacer(),
//                                 InkWell(
//                                   onTap: () {
//                                     final profileUser =
//                                         profileController
//                                             .getUserByIdResponseModel
//                                             .userforProfile;
//                                     if (profileUser != null) {
//                                       Get.to(
//                                         EditProfile(userProfile: profileUser),
//                                       );
//                                     } else {
//                                       Get.snackbar(
//                                         'Error',
//                                         'User data not loaded yet',
//                                       );
//                                     }
//                                   },
//                                   child: Image.asset(
//                                     'assets/icons/edit.png',
//                                     height: 70,
//                                     width: 70,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),

//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ListView(
//                                 children: [
//                                   SizedBox(height: 30),
//                                   _buildMenuItem(
//                                     Icons.info_outline,
//                                     "About App",
//                                     onTap: () {
//                                       Get.to(AboutAppScreen());
//                                     },
//                                   ),
//                                   _divider(),
//                                   _buildMenuItem(
//                                     Icons.privacy_tip_outlined,
//                                     "Privacy Policy",
//                                     onTap: () {
//                                       Get.to(PrivacyPolicyScreen());
//                                     },
//                                   ),
//                                   _divider(),
//                                   _buildMenuItem(
//                                     Icons.article_outlined,
//                                     "Term & Condition",
//                                     onTap: () {
//                                       Get.to(TearmAndConditonScreen());
//                                     },
//                                   ),
//                                   _divider(),
//                                   _buildMenuItem(
//                                     Icons.lock_outline,
//                                     "Change Password",
//                                     onTap: () {
//                                       Get.to(ChangePasswordScreen());
//                                     },
//                                   ),
//                                   _divider(),
//                                   _buildMenuItem(
//                                     Icons.notifications_outlined,
//                                     "Notification",
//                                     onTap: () {
//                                       Get.to(NotificationScreen());
//                                     },
//                                   ),
//                                   _divider(),
//                                   _buildMenuItem(
//                                     Icons.logout,
//                                     "Log Out",
//                                     color: Colors.red,
//                                     onTap: () {
//                                       Get.to(SignInScreen());
//                                     },
//                                   ),
//                                   _divider(),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//             : Container(child: Center(child: CircularProgressIndicator()));
//       },
//     );
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
