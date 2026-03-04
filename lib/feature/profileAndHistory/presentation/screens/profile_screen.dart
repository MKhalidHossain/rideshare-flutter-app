import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/feature/profileAndHistory/controllers/profile_and_history_controller.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/account_security_screen.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/delete_account_screen.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/edit_profile_screen.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/notifications_screen.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/terms_and_condition.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';
import '../../../../core/constants/app_colors.dart';
import 'privacy_policy_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authController = Get.find<AuthController>();
  ProfileAndHistoryController profileController = Get.find<ProfileAndHistoryController>();

  @override
  void initState() {
    super.initState();
    if (authController.isLoggedIn()) {
      profileController.getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!authController.isLoggedIn()) {
      return SafeArea(
        child: _buildGuestProfile(context),
      );
    }
    return SafeArea(
      child: GetBuilder<ProfileAndHistoryController>(
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading
                ? _buildProfileShimmer(context)
                : _buildProfileContent(context, controller),
          );
        },
      ),
    );
  }

  /// 🔹 When data is loading, show shimmer placeholders for each section
  Widget _buildProfileShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Center(child: ShimmerLine(width: 150, height: 18)),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: const [
              ShimmerCircle(size: 80),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLine(width: 140, height: 16),
                    SizedBox(height: 8),
                    ShimmerLine(width: 200, height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, __) => _buildProfileMenuShimmerItem(),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenuShimmerItem() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          ShimmerCircle(size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLine(width: 160, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 220, height: 12),
              ],
            ),
          ),
          ShimmerLine(width: 16, height: 12),
        ],
      ),
    );
  }

  /// 🔹 Actual profile content after loading completes
  Widget _buildProfileContent(
    BuildContext context,
    ProfileAndHistoryController controller,
  ) {
    return Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xffCE0000).withOpacity(0.8),
                        const Color(0xff7B0100).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: ClipOval(
                    child: Builder(
                      builder: (context) {
                        final imageUrl = controller
                            .getProfileResponseModel
                            .data
                            ?.profileImage;
                        if (imageUrl == null || imageUrl.isEmpty) {
                          return Center(
                            child: Icon(
                              Icons.person_outline,
                              size: 30,
                              color: Colors.grey,
                            ),
                          );
                        }
                        return Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const ShimmerSkeleton(
                              child: ColoredBox(color: kShimmerFillColor),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.person_outline,
                                size: 30,
                                color: Colors.grey,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.getProfileResponseModel.data?.fullName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'outfit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildMenuItem(
                  Icons.person_outline,
                  "Profile",
                  "Customize your profile",
                  onTap: () {
                    Get.to(
                      () => EditProfile(
                        userProfile: controller.getProfileResponseModel.data,
                      ),
                    );
                  },
                ),
                _divider(),
                // _buildMenuItem(
                //   Icons.wallet_outlined,
                //   "Wallet",
                //   "Term of services",
                //   onTap: () {
                //     Get.to(() => WalletScreen());
                //   },
                // ),
                _divider(),
                _buildMenuItem(
                  Icons.notifications_outlined,
                  "Manage Notifications",
                  "Customize alerts",
                  onTap: () {
                    Get.to(() => NotificationsScreen());
                  },
                ),
                _divider(),
                _buildMenuItem(
                  Icons.lock_outline,
                  "Account Security",
                  "Change your password",
                  onTap: () {
                    Get.to(() => const AccountSecurityScreen());
                  },
                ),
                _divider(),
                _buildMenuItem(
                  Icons.help_outline,
                  "Terms & Conditions",
                  "Terms & Services",
                  onTap: () {
                    Get.to(() => TermsAndCondition());
                  },
                ),
                _divider(),
                _buildMenuItem(
                  Icons.shield_outlined,
                  "Privacy Policy",
                  "Privacy policy",
                  onTap: () {
                    Get.to(PrivacyPolicyScreen());
                  },
                ),
                _divider(),
                _buildMenuItem(
                  Icons.delete_outline,
                  "Delete Account",
                  "Request account deletion",
                  color: const Color(0xffCE0000).withOpacity(0.8),
                  onTap: () {
                    Get.to(
                      () => DeleteAccountScreen(
                        prefilledEmail:
                            controller.getProfileResponseModel.data?.email,
                      ),
                    );
                  },
                ),
                _divider(),
                _buildMenuItem(
                  Icons.logout,
                  "Log Out",
                  "Sign out of your account",
                  color: const Color(0xffCE0000).withOpacity(0.8),
                  onTap: () async {
                    await Get.find<AuthController>().logOut();
                  },
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xffCE0000).withOpacity(0.8),
                          const Color(0xff7B0100).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: const ClipOval(
                      child: Center(
                        child: Icon(
                          Icons.person_outline,
                          size: 30,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Guest User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  WideCustomButton(
                    text: 'Log In / Create Account',
                    onPressed: () {
                      Get.to(() => const UserLoginScreen());
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildMenuItem(
                    Icons.help_outline,
                    "Terms & Conditions",
                    "Terms & Services",
                    onTap: () {
                      Get.to(() => TermsAndCondition());
                    },
                  ),
                  _divider(),
                  _buildMenuItem(
                    Icons.shield_outlined,
                    "Privacy Policy",
                    "Privacy policy",
                    onTap: () {
                      Get.to(PrivacyPolicyScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
            color: const Color(0xffD8D8D8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: color == const Color(0xffCE0000).withOpacity(0.8)
                ? const Color(0xffCE0000).withOpacity(0.8)
                : Colors.white,
            fontSize: 16,
            fontFamily: 'outfit',
            fontWeight: FontWeight.bold,
          ),
        ),
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
