// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/historyAndProfile/presentation/screens/history_screen.dart';
import 'package:rideztohealth/feature/home/presentation/widgets/recent_single_contianer.dart';
import 'package:rideztohealth/feature/map/presentation/screens/search_destination_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/promo_banner_widget.dart';
import '../../../historyAndProfile/presentation/screens/saved_places_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              //  TextFormField(
              //             controller: _emailController,
              //             focusNode: _emailFocus,
              //             keyboardType: TextInputType.emailAddress,
              //             decoration: InputDecoration(
              //               prefixIcon: Padding(
              //                 padding: EdgeInsets.all(12.0),
              //                 child: Image.asset(
              //                   'assets/images/email.png',
              //                   width: 24,
              //                   height: 24,
              //                   fit: BoxFit.contain,
              //                 ),
              //               ),
              //               hint: Text(
              //                 'Enter your email',
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   color: Color(0xFFFFFFFF).withOpacity(0.3),
              //                 ),
              //               ),

              //               border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 borderSide: BorderSide(
              //                   color: Colors.grey.shade400,
              //                 ),
              //               ),
              //             ),
              //             onFieldSubmitted: (_) =>
              //                 FocusScope.of(context).requestFocus(_emailFocus),
              //             textInputAction: TextInputAction.done,
              //             validator: Validators.email,
              //             style: TextStyle(
              //               color: AppColors.context(context).textColor,
              //               fontSize: 16,
              //               fontWeight: FontWeight.w400,
              //             ),
              //             autofillHints: const [AutofillHints.email],
              //           ),
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
                          color: Color(0xFF2C3E50),
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
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),

              // GestureDetector(
              //   onTap: () {
              //     Get.to(SearchDestinationScreen());
              //   },
              //   child: AbsorbPointer(
              //     child: TextField(
              //       decoration: InputDecoration(
              //         filled: true,
              //         fillColor: Colors.white24,
              //         hintText: 'Enter Destination',
              //         hintStyle: const TextStyle(color: Colors.white54),
              //         prefixIcon: const Icon(Icons.search, color: Colors.white),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(8),
              //           borderSide: BorderSide.none,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
              _buildSectionTitle('Recent Trips'),
              // Column(
              //   children: recentTrips
              //       .map((trip) => _buildTripTile(trip))
              //       .toList(),
              // ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.to(HistoryScreen());
                },
                child: SingleActivityContainer(
                  title: 'New York City',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.to(HistoryScreen());
                },
                child: SingleActivityContainer(
                  title: 'Los Anageles',
                  subTitle: 'June 25, 07:16 am',
                  price: '\$99.99 USD',
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Saved Places'),

              // Column(
              //   children: savedPlaces
              //       .map((place) => _buildSavedTile(place))
              //       .toList(),
              // ),

              // Saved Places
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.to(SavedPlaceScreen());
                },
                child: SavedPlaceSingeContainer(
                  title: 'Mom\'s House',
                  subTitle: '321 Family Rd',
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Get.to(SavedPlaceScreen());
                },
                child: SavedPlaceSingeContainer(
                  title: 'Airport',
                  subTitle: 'International Terminal',
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Our Services'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildServiceCard('Taxi Name')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildServiceCard('Taxi Name')),
                  const SizedBox(width: 10),
                  Expanded(child: _buildServiceCard('Taxi Name')),
                ],
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

  Widget _buildServiceCard(String label) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ServiceScreen()),
      );
    },
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
          Image.asset(
            'assets/images/taxi_ourService.png',
            fit: BoxFit.contain,
            height: 40,
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

  // Widget _buildPromoBanner() => Container(
  //   decoration: BoxDecoration(
  //     color: Colors.white10,
  //     borderRadius: BorderRadius.circular(12),
  //   ),
  //   child: Row(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(24.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'Enjoy 18% off next ride',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 24),
  //             NormalCustomButton(
  //               height: 30,
  //               weight: 100,
  //               text: 'Book Now',
  //               onPressed: () {},
  //             ),
  //           ],
  //         ),
  //       ),
  //       const Spacer(),
  //       Image.asset(
  //         'assets/images/promoImage.png',
  //         fit: BoxFit.contain,
  //         height: 120,
  //       ),
  //     ],
  //   ),
  // );
}
