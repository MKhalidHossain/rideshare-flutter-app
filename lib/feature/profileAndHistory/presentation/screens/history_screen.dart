import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';

import '../../../../core/utils/date_time_formatter.dart';
import '../../../home/presentation/widgets/recent_single_contianer.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        final recentTrips =
            homeController.getRecentTripsResponseModel.value.data?.rides  ?? [];
        return homeController.isLoading
            ? const Center(child: CircularProgressIndicator())
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
}
