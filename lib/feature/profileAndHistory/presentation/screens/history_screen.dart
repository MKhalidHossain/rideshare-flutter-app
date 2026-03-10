import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';

import '../../../../core/utils/date_time_formatter.dart';
import '../../../home/presentation/widgets/recent_single_contianer.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    if (!authController.isLoggedIn()) {
      return _buildGuestContent(context);
    }
    return GetBuilder<HomeController>(
      builder: (homeController) {
        final recentTrips =
            homeController.getRecentTripsResponseModel.value.data?.rides  ?? [];
        return homeController.isLoading
            ? _buildLoadingShimmer(context)
            : SafeArea(
                bottom: false,
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: false,
                    title: 'Your All Activity'.text22White(),
                    backgroundColor: Colors.transparent,
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          recentTrips.isEmpty
                              ? Center(
                                  child: Text(
                                    "No riding history found yet",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recentTrips.length > 2
                                      ? 2
                                      : recentTrips.length, // ✅ max 2 items,
                                  itemBuilder: (context, index) {
                                    final trip = recentTrips[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(HistoryScreen());
                                          },
                                          child: SingleActivityORTripContainer(
                                            title:
                                                trip.dropoffLocation?.address ??
                                                'Unknown Location',
                                            subTitle: DateTimeFormatter.format(
                                              trip.createdAt ?? '',
                                            ),
                                            price:
                                                "\$ ${trip.finalFare.toString()} USD",
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  },
                                ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const ShimmerLine(width: 160, height: 18),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHistoryItemShimmer(),
              const SizedBox(height: 16),
              _buildHistoryItemShimmer(),
              const SizedBox(height: 16),
              _buildHistoryItemShimmer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItemShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Row(
        children: const [
          ShimmerCircle(size: 40),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(width: 200, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 140, height: 12),
                SizedBox(height: 6),
                ShimmerLine(width: 100, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestContent(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: 'Your Activity'.text22White(),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 88,
                  width: 88,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.history,
                    size: 40,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'You are using Guest Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Log in to see your ride history and activity.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                WideCustomButton(
                  text: 'Log In',
                  onPressed: () {
                    Get.to(() => const UserLoginScreen());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
