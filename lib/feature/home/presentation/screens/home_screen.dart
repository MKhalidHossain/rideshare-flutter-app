// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/core/utils/date_time_formatter.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/history_screen.dart';
import 'package:rideztohealth/feature/home/presentation/widgets/recent_single_contianer.dart';
import 'package:rideztohealth/feature/map/presentation/screens/work/search_destination_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/promo_banner_widget.dart';
import '../../../../core/widgets/shimmer/shimmer_skeleton.dart';
import '../../../profileAndHistory/presentation/screens/saved_places_screen.dart';
import '../../../serviceFeature/presentation/screens/service_screen.dart';
import '../widgets/saved_pleaces_single_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> recentTrips = ["New York City", "New York City"];

  List<String> savedPlaces = ["Mom's House", "Airport"];

  HomeController homeController = Get.find<HomeController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    homeController.getAllServices();
    if (authController.isLoggedIn()) {
      homeController.getSavedPlaces();
      homeController.getRecentTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(
      builder: (homeController) {
        final isLoggedIn = authController.isLoggedIn();
        final name = homeController
            .getAllCategoryResponseModel
            .data
            ?.first
            .name;
        print("Nmae form category: $name");
        final savedPlaces =
            homeController.getSavedPlacesResponseModel.data ?? [];
      
        return homeController.isLoading
            ? _buildHomeShimmer(context)
            : Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.context(context).iconColor,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 8),
                                'Current location'.text18White500(),
                                'Dhaka City'.textColorWhite(10),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF303644),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: SearchDestinationScreen(
                                     scrollController: controller,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white24,
                                hintText: 'Enter Destination',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionTitle('Recent Trips'),
                        const SizedBox(height: 16),
                        if (!isLoggedIn)
                          _buildLoginPrompt(
                            'Sign in to view your recent trips.',
                          )
                        else
                          ObxValue(
                            (data) {
                              final recentTrips = homeController
                                      .getRecentTripsResponseModel
                                      .value
                                      .data
                                      ?.rides ??
                                  [];
                              return (recentTrips).isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 40,
                                        ),
                                        child: 'You have not taken any trips yet.'
                                            .text16White500(),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                              child:
                                                  SingleActivityORTripContainer(
                                                title: trip.dropoffLocation
                                                        ?.address ??
                                                    'Unknown Location',
                                                subTitle:
                                                    DateTimeFormatter.format(
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
                                    );
                            },
                            homeController.getRecentTripsResponseModel,
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Saved Places'),
                            TextButton(
                              onPressed: () {
                                if (!isLoggedIn) {
                                  Get.to(() => const UserLoginScreen());
                                  return;
                                }
                                Get.to(SavedPlaceScreen());
                              },
                              child: 'See All'.textColorWhite(14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (!isLoggedIn)
                          _buildLoginPrompt(
                            'Sign in to manage your saved places.',
                          )
                        else
                          savedPlaces.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 40,
                                    ),
                                    child: 'No saved places yet.'
                                        .text16White500(),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: savedPlaces.length > 2
                                      ? 2
                                      : savedPlaces.length, // ✅ max 2,
                                  itemBuilder: (context, index) {
                                    final place = savedPlaces[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(SavedPlaceScreen());
                                          },
                                          child: SavedPlaceSingeContainer(
                                            title: place.name ?? 'Unknown',
                                            subTitle:
                                                place.address ?? 'No Address',
                                            isShowDeleteButton: false,
                                            placeId: place.id.toString(),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    );
                                  },
                                ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('Our Services'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                (homeController
                                            .getAllCategoryResponseModel
                                            .data
                                            ??
                                        [])
                                    .map((Services) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        child: _buildServiceCard(
                                          Services.name ?? 'Unknown',
                                          Services.serviceImage ??
                                              'assets/images/texi.png',
                                          () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const ServiceScreen(),
                                              ),
                                            );
                                          },
                                          size,
                                        ),
                                      );
                                    })
                                    .toList(),
                          ),
                        ),

                        const SizedBox(height: 24),
                        PromoBannerWidget(
                          title: 'Enjoy 18% off next ride',
                          buttonText: 'Book Now',
                          onPressed: () {
                            // Your action
                          },
                          imagePath: 'assets/images/promoImage.png',
                        ),

                        // _buildPromoBanner(),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
  );

  Widget _buildTripTile(String trip) {
    return ListTile(
      leading: Icon(Icons.access_time, color: Colors.grey),
      title: Text(trip),
      trailing: TextButton(
        onPressed: () {
          setState(() {
            recentTrips.remove(trip);
          });
        },
        child: const Text('Remove', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildSavedTile(String place) => ListTile(
    leading: Icon(Icons.place_outlined, color: Colors.grey),
    title: Text(place),
    subtitle: const Text('Search terminal'),
  );

  Widget _buildServiceCard(
    String label,
    String image,
    VoidCallback onTap,
    size,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.context(context).borderColor),
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image.trim().isEmpty
              ? const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                )
              : Image.network(
                  image,
                  fit: BoxFit.contain,
                  height: 40,
                  width: size.width * 0.20,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const ShimmerBox(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    );
                  },
                ),

          //Icon(Icons.local_taxi, size: 32, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildLoginPrompt(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            message.text16White500(),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Get.to(() => const UserLoginScreen());
              },
              child: 'Sign in'.textColorWhite(14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeShimmer(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                children: [
                  const ShimmerCircle(size: 32),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerLine(width: 130, height: 14),
                      SizedBox(height: 6),
                      ShimmerLine(width: 90, height: 12),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const ShimmerBox(
                width: double.infinity,
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              const SizedBox(height: 16),
              const ShimmerLine(width: 120, height: 16),
              const SizedBox(height: 16),
              _buildTripShimmerCard(),
              const SizedBox(height: 12),
              _buildTripShimmerCard(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ShimmerLine(width: 120, height: 16),
                  ShimmerLine(width: 60, height: 12),
                ],
              ),
              const SizedBox(height: 16),
              _buildSavedPlaceShimmerCard(),
              const SizedBox(height: 12),
              _buildSavedPlaceShimmerCard(),
              const SizedBox(height: 16),
              const ShimmerLine(width: 140, height: 16),
              const SizedBox(height: 16),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => _buildServiceShimmerCard(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemCount: 3,
                ),
              ),
              const SizedBox(height: 24),
              _buildPromoShimmerCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripShimmerCard() {
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
                ShimmerLine(width: 180, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 140, height: 12),
                SizedBox(height: 6),
                ShimmerLine(width: 90, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPlaceShimmerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Row(
        children: const [
          ShimmerCircle(size: 36),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLine(width: 160, height: 14),
                SizedBox(height: 6),
                ShimmerLine(width: 200, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceShimmerCard() {
    return Container(
      width: 140,
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
            width: 50,
            height: 50,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          SizedBox(height: 10),
          ShimmerLine(width: 90, height: 12),
        ],
      ),
    );
  }

  Widget _buildPromoShimmerCard() {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
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
    );
  }
}
