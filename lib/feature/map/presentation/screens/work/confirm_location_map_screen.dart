import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';
import 'package:rideztohealth/core/widgets/wide_custom_button.dart';
import 'package:rideztohealth/feature/auth/controllers/auth_controller.dart';
import 'package:rideztohealth/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:rideztohealth/feature/home/controllers/home_controller.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import 'package:rideztohealth/feature/home/domain/request_model/ride_booking_info_request_model.dart';
import '../../../../../utils/display_helper.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/locaion_controller.dart';
import 'finding_your_driver_screen.dart';

// import 'chat_screen.dart'; // Uncomment if you use these
// import 'call_screen.dart'; // Uncomment if you use these
// import 'payment_screen.dart'; // Uncomment if you use these// Import the new search screen

// ignore: use_key_in_widget_constructors
class ConfirmYourLocationScreen extends StatelessWidget {
  ConfirmYourLocationScreen({super.key, this.selectedDriver});

  final NearestDriverData? selectedDriver;

  // Bottom sheet height control for quick tweaking
  static const double _sheetHeightFactor =
      0.35; // adjust here to change default height

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Default to Dhaka, Bangladesh
    zoom: 14.0,
  );

  final LocationController locationController = Get.find<LocationController>();

  final HomeController homeController = Get.find<HomeController>();

  final AppController appController = Get.find<AppController>();
  final AuthController authController = Get.find<AuthController>();

  double _calculateEstimatedPriceValue(
    double distanceMiles, {
    num? baseFare,
    num? perMileRate,
    num? minimumFare,
  }) {
    final double resolvedBaseFare = (baseFare ?? 5).toDouble();
    final double resolvedPerMileRate = (perMileRate ?? 2.5).toDouble();

    double price = resolvedBaseFare + (distanceMiles * resolvedPerMileRate);

    if (minimumFare != null) {
      price = price < minimumFare ? minimumFare.toDouble() : price;
    }

    return price;
  }

  bool _isCommissionActive(Commission? commission) {
    if (commission == null) return false;
    if (commission.isActive == false) return false;
    if (commission.status != null && commission.status != 'active') {
      return false;
    }
    final now = DateTime.now();
    if (commission.startDate != null && now.isBefore(commission.startDate!)) {
      return false;
    }
    if (commission.endDate != null && now.isAfter(commission.endDate!)) {
      return false;
    }
    return commission.commission != null &&
        commission.commission!.toDouble() > 0;
  }

  double _applyCommissionDiscount(
    double originalPrice,
    Commission? commission,
  ) {
    if (!_isCommissionActive(commission)) return originalPrice;
    final discountValue = commission!.commission!.toDouble();
    final discountType = commission.discountType?.toLowerCase().trim();

    double discountedPrice;
    if (discountType == 'percentage') {
      discountedPrice = originalPrice * (1 - (discountValue / 100));
    } else {
      discountedPrice = originalPrice - discountValue;
    }

    return discountedPrice < 0 ? 0 : discountedPrice;
  }

  Future<void> _handleConfirmLocation() async {
    if (!authController.isLoggedIn()) {
      final shouldLogin = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF303644),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          title: const Text('Sign in required'),
          content: const Text(
            'You need to sign in to confirm your location and book a ride.',
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: InkWell(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Color(0xFF303644),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: InkWell(
                      onTap: () => Get.back(result: true),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            stops: [0.0, 0.4, 9.0],
                            colors: [
                              Color(0xff7B0100).withOpacity(0.8),
                              Color(0xFFCE0000),
                              Color(0xff7B0100).withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        barrierDismissible: true,
      );
      if (shouldLogin == true) {
        Get.to(() => const UserLoginScreen());
      }
      return;
    }

    final driverData = selectedDriver;
    final pickupLatLng =
        locationController.pickupLocation.value ??
        locationController.currentLocation.value;
    final destinationLatLng = locationController.destinationLocation.value;

    if (driverData == null) {
      appController.showErrorSnackbar('Please select a driver to continue');
      return;
    }

    if (pickupLatLng == null) {
      appController.showErrorSnackbar('Pickup location is missing');
      return;
    }

    if (destinationLatLng == null) {
      appController.showErrorSnackbar('Please select a destination');
      return;
    }

    final originalFareValue = _calculateEstimatedPriceValue(
      locationController.distance.value,
      baseFare: driverData.service?.baseFare,
      perMileRate: driverData.service?.effectivePerMileRate,
      minimumFare: driverData.service?.minimumFare,
    );
    final discountedFareValue = _applyCommissionDiscount(
      originalFareValue,
      driverData.commission,
    );
    final totalFare = discountedFareValue.toStringAsFixed(2);

    final bookingInfo = RideBookingInfo(
      driverId: driverData.driver.id,
      pickupLocation: Location(
        coordinates: [pickupLatLng.longitude, pickupLatLng.latitude],
        address: locationController.pickupAddress.value.isNotEmpty
            ? locationController.pickupAddress.value
            : 'Current Location',
      ),
      dropoffLocation: Location(
        coordinates: [destinationLatLng.longitude, destinationLatLng.latitude],
        address: locationController.destinationAddress.value.isNotEmpty
            ? locationController.destinationAddress.value
            : 'Destination',
      ),
      totalFare: totalFare,
      rideDuration: locationController.distance.value.toStringAsFixed(2),
    );

    appController.showLoading();
    try {
      final response = await homeController.requestRide(bookingInfo);

      if (response.success == true) {
        appController.showSuccessSnackbar(
          response.message ?? 'Ride requested successfully',
        );
        appController.setCurrentScreen('confirm');
        Get.to(
          () => FindingYourDriverScreen(
            selectedDriver: selectedDriver,
            rideBookingInfoFromResponse: response,
          ),
        );
      } else {
        appController.showErrorSnackbar(
          response.message ?? 'Unable to request ride',
        );
      }
    } catch (e) {
      appController.showErrorSnackbar(e.toString());
    } finally {
      appController.hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                locationController.setMapController(controller);
                // Move camera to current location if available
                if (locationController.currentLocation.value != null) {
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      locationController.currentLocation.value!,
                      14.0,
                    ),
                  );
                }
              },
              initialCameraPosition: _initialPosition,
              markers: locationController.markers,
              polylines: locationController.polylines, // Display polyline
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              zoomControlsEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onTap: (LatLng position) {
                // Allow changing destination by tapping on the map
                locationController.setDestinationLocation(position);
                // The polyline and distance will regenerate automatically due to everAll listener
              },
            ),

            // Back button (top left as seen in previous screenshot type)
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            // Red target icon in the middle right
            Positioned(
              top:
                  MediaQuery.of(context).size.height *
                  0.55, // Approximately center vertically
              right: 20,
              child: GestureDetector(
                onTap: () {
                  // Re-center map on current location or destination
                  if (locationController.currentLocation.value != null &&
                      locationController.mapController.value != null) {
                    locationController.mapController.value!.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        locationController.currentLocation.value!,
                        14.0,
                      ),
                    );
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.my_location, color: Colors.white, size: 30),
                ),
              ),
            ),

            // CONFIRM YOUR LOCATION BOTTOM SHEET
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height:
                    MediaQuery.of(context).size.height *
                    _sheetHeightFactor, // change factor to adjust default height
                padding: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF303644), // Dark grey from the image
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Get.back(), // Go back to previous screen
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          Text(
                            'Confirm your location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 24), // For alignment
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10, // Card background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // From: Current Location
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 25,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "From:".text12White(),
                                      Text(
                                        "Your location",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            // To: Destination Location (Changeable/Editable)
                            GestureDetector(
                              onTap: () {
                                //  Get.to(() => DestinationSearchScreen());
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        'To:'.text12White(),
                                        Obx(
                                          () => Text(
                                            locationController
                                                    .destinationAddress
                                                    .value
                                                    .isEmpty
                                                ? 'Select Destination'
                                                : locationController
                                                      .destinationAddress
                                                      .value,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() {
                                    if (locationController
                                                .destinationLocation
                                                .value !=
                                            null &&
                                        locationController.distance.value > 0) {
                                      return Text(
                                        '${locationController.distance.value.toStringAsFixed(1)} Miles',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      );
                                    }
                                    return SizedBox.shrink();
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      //               if (selectedDriver != null)
                      //                 Container(
                      //                   width: double.infinity,
                      //                   padding: const EdgeInsets.all(14),
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.white10,
                      //                     borderRadius: BorderRadius.circular(10),
                      //                   ),
                      //                   child: Row(
                      //                     children: [
                      //                       ClipRRect(
                      //                         borderRadius: BorderRadius.circular(8),
                      //                         child: Image.network(
                      //                           selectedDriver!.service.serviceImage,
                      //                           height: 60,
                      //                           width: 80,
                      //                           fit: BoxFit.cover,
                      //                           errorBuilder: (_, __, ___) => Image.asset(
                      //                             'assets/images/privet_car.png',
                      //                             height: 60,
                      //                             width: 80,
                      //                             fit: BoxFit.cover,
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       const SizedBox(width: 12),
                      //                       Expanded(
                      //                         child: Column(
                      //                           crossAxisAlignment: CrossAxisAlignment.start,
                      //                           children: [
                      //                             Text(
                      //                               selectedDriver!.service.name,
                      //                               style: const TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.bold,
                      //                               ),
                      //                             ),
                      //                             Text(
                      //                               "${selectedDriver!.vehicle.taxiName} • Plate ${selectedDriver!.vehicle.plateNumber}",
                      //                               style: const TextStyle(
                      //                                 color: Colors.grey,
                      //                                 fontSize: 13,
                      //                               ),
                      //                             ),
                      //                             const SizedBox(height: 4),
                      //                             // 👉 THIS PART: COMMENT OUT / DELETE
                      // Obx(() {
                      //   if (locationController
                      //               .destinationLocation.value !=
                      //           null &&
                      //       locationController.distance.value > 0) {
                      //     return Text(
                      //       '${locationController.distance.value.toStringAsFixed(1)} miles',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 15,
                      //       ),
                      //     );
                      //   }
                      //   return SizedBox.shrink();
                      // }),
                      //                           ],
                      //                         ),
                      //                       ),
                      //                       Text(
                      //                         "${selectedDriver!.service.estimatedArrivalTime} min",
                      //                         style: const TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 14,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      SizedBox(height: 12),

                      // Confirm Location Button
                      WideCustomButton(
                        text: 'Confirm Location',
                        isLoading: appController.isLoading.value,
                        onPressed: _handleConfirmLocation,
                      ),
                      // Container(
                      //   width: double.infinity,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       appController.setCurrentScreen('confirm');
                      //       Get.to(
                      //         () => FindingYourDriverScreen(
                      //           selectedDriver: selectedDriver,
                      //         ),
                      //       );
                      //     },
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: const Color(0xFFC0392B), // Red color
                      //       padding: EdgeInsets.symmetric(vertical: 15),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     child: Text(
                      //      'Confirm Location',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            // Loading overlay
            if (appController.isLoading.value)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        ShimmerCircle(size: 32),
                        SizedBox(height: 12),
                        ShimmerLine(width: 180, height: 14),
                        SizedBox(height: 8),
                        ShimmerLine(width: 240, height: 12),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../controllers/app_controller.dart';
// import '../../controllers/booking_controller.dart'; // Keep if used for other data, otherwise can remove
// import '../../controllers/locaion_controller.dart';
// import 'location_confirmation_screen.dart'; // The next step after confirming// To allow changing destination from here
// // import 'chat_screen.dart'; // Uncomment if you use these
// // import 'call_screen.dart'; // Uncomment if you use these
// // import 'payment_screen.dart'; // Uncomment if you use these

// class ConfirmLocationMapScreen extends StatelessWidget {
//   final LocationController locationController = Get.find<LocationController>();
//   final BookingController bookingController = Get.find<BookingController>();
//   final AppController appController = Get.find<AppController>();

//   static const CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(23.8103, 90.4125), // Default to Dhaka, Bangladesh
//     zoom: 14.0,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//             () => Stack(
//           children: [
//             GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 locationController.setMapController(controller);
//                 if (locationController.currentLocation.value != null) {
//                   controller.animateCamera(
//                     CameraUpdate.newLatLngZoom(
//                       locationController.currentLocation.value!,
//                       14.0,
//                     ),
//                   );
//                 }
//               },
//               initialCameraPosition: _initialPosition,
//               markers: locationController.markers,
//               polylines: locationController.polylines, // Display polyline
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               onTap: (LatLng position) {
//                 // Allow changing destination by tapping on the map
//                 locationController.setDestinationLocation(position);
//                 // The polyline and distance will regenerate automatically due to everAll listener
//               },
//             ),

//             // Back button (top left as seen in previous screenshot type)
//             Positioned(
//               top: 50,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.arrow_back, color: Colors.black),
//                 ),
//               ),
//             ),
//             // Red target icon in the middle right
//             Positioned(
//               top: MediaQuery.of(context).size.height * 0.45, // Approximately center vertically
//               right: 20,
//               child: FloatingActionButton(
//                 mini: true,
//                 backgroundColor: Colors.red, // Changed to red for consistency with screenshot
//                 onPressed: () {
//                   if (locationController.currentLocation.value != null && locationController.mapController.value != null) {
//                     locationController.mapController.value!.animateCamera(
//                       CameraUpdate.newLatLngZoom(locationController.currentLocation.value!, 14.0),
//                     );
//                   } else {
//                     locationController.getCurrentLocation(); // Attempt to get current location if not available
//                   }
//                 },
//                 child: Icon(Icons.my_location, color: Colors.white),
//               ),
//             ),

//             // CONFIRM YOUR LOCATION BOTTOM SHEET
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: MediaQuery.of(context).padding.bottom + 10),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2E2E38), // Dark grey from the image
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       height: 5,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[700],
//                         borderRadius: BorderRadius.circular(2.5),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Get.back(), // Go back to set ride screen
//                           child: Icon(Icons.arrow_back, color: Colors.white),
//                         ),
//                         Text(
//                           'Confirm your location',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 24), // For alignment
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 0),
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF3B3B42), // Card background color
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         children: [
//                           // From: Current Location
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Column(
//                                 children: [
//                                   Container(
//                                     width: 8,
//                                     height: 8,
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 2,
//                                     height: 25, // Height for the connecting line
//                                     color: Colors.red,
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'From:',
//                                       style: TextStyle(color: Colors.grey, fontSize: 12),
//                                     ),
//                                     Obx(() => Text(
//                                       locationController.pickupAddress.value.isEmpty
//                                           ? 'Current Location'
//                                           : locationController.pickupAddress.value,
//                                       style: TextStyle(color: Colors.white, fontSize: 15),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     )),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 5), // Space between From and To
//                           // To: Destination Location (Changeable/Editable)
//                           GestureDetector(
//                             onTap: () {
//                             //  Get.to(() => DestinationSearchScreen()); // Allows changing the destination
//                             },
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Column(
//                                   children: [
//                                     Container(
//                                       width: 8,
//                                       height: 8,
//                                       decoration: BoxDecoration(
//                                         color: Colors.red,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'To:',
//                                         style: TextStyle(color: Colors.grey, fontSize: 12),
//                                       ),
//                                       Obx(() => Text(
//                                         locationController.destinationAddress.value.isEmpty
//                                             ? 'Select Destination' // Default text
//                                             : locationController.destinationAddress.value,
//                                         style: TextStyle(color: Colors.white, fontSize: 15),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       )),
//                                     ],
//                                   ),
//                                 ),
//                                 Obx(() {
//                                   // Only show distance if destination is set and distance is calculated
//                                   if (locationController.destinationLocation.value != null && locationController.distance.value > 0) {
//                                     return Text(
//                                       '${locationController.distance.value.toStringAsFixed(1)} miles',
//                                       style: TextStyle(color: Colors.white, fontSize: 15),
//                                     );
//                                   }
//                                   return SizedBox.shrink(); // Hide if no destination or distance is zero
//                                 }),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     // Confirm Location Button
//                     Container(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Action for "Confirm Location" - leads to driver arriving screen
//                           Get.to(() => LocationConfirmationScreen()); // Assuming this leads to the next step, as per your old code
//                           // You might want to update this to Get.to(() => RideConfirmedScreen()); based on the new flow
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFC0392B), // Red color
//                           padding: EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           'Confirm Location',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Loading overlay
//             Obx(() => appController.isLoading.value
//                 ? Container(
//                     color: Colors.black54,
//                     child: Center(
//                       child: CircularProgressIndicator(color: Colors.red),
//                     ),
//                   )
//                 : SizedBox.shrink()),
//           ],
//         ),
//       ),
//     );
//   }
// }
