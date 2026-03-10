// lib/screens/service_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';
import 'package:rideztohealth/feature/map/presentation/screens/work/search_destination_screen.dart';

import '../../../../core/widgets/promo_banner_widget.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  int selectedService = 0;

  HomeController homeController = Get.find<HomeController>();

  void _openRideBookingFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.85,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF303644),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SearchDestinationScreen(scrollController: controller),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getAllServices();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        final services = homeController.getAllCategoryResponseModel.data ?? [];

        return homeController.isLoading
            ? _buildLoadingShimmer(context)
            : Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Our Services".text22White(),
                        const SizedBox(height: 8),
                        "From here to there — and everything in between."
                            .text14White(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: services.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No services found yet",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 1.2,
                                      ),
                                  itemCount: services.length,
                                  itemBuilder: (context, index) {
                                    final service = services[index];
                                    final isSelected = selectedService == index;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedService = index;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(
                                                  0xffEA0001,
                                                ).withValues(alpha: 0.04)
                                              : Colors.white10,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(
                                                    0xffEA0001,
                                                  ).withValues(alpha: 0.8)
                                                : Colors.white10,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            (service.serviceImage == null ||
                                                    service.serviceImage!
                                                        .trim()
                                                        .isEmpty)
                                                ? const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )
                                                : Image.network(
                                                    service.serviceImage!,
                                                    fit: BoxFit.contain,
                                                    height: 60,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => const Icon(
                                                          Icons.broken_image,
                                                          color: Colors.white,
                                                          size: 40,
                                                        ),
                                                  ),
                                            const SizedBox(height: 8),
                                            Text(
                                              service.name ?? 'No Name',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const SizedBox(height: 16),
                        PromoBannerWidget(
                          title: 'Book your next ride',
                          buttonText: 'Book Now',
                          onPressed: _openRideBookingFlow,
                          imagePath: 'assets/images/promoImage.png',
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildLoadingShimmer(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerLine(width: 140, height: 20),
              const SizedBox(height: 8),
              const ShimmerLine(width: 240, height: 14),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12, width: 1),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerBox(
                            width: 60,
                            height: 60,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          SizedBox(height: 10),
                          ShimmerLine(width: 110, height: 12),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerLine(width: 180, height: 14),
                          SizedBox(height: 8),
                          ShimmerLine(width: 120, height: 12),
                          SizedBox(height: 16),
                          ShimmerBox(
                            width: 90,
                            height: 28,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    ShimmerBox(
                      width: 70,
                      height: 70,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
