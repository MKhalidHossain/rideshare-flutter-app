import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import '../../../../home/domain/reponse_model/request_ride_response_model.dart';
import '../../../../home/domain/request_model/ride_booking_info_request_model.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/booking_controller.dart';
import '../../../controllers/locaion_controller.dart';
import '../ride_confirmed_screen.dart';
// import 'chat_screen.dart'; // Uncomment if you use these
// import 'call_screen.dart'; // Uncomment if you use these
// import 'payment_screen.dart'; // Uncomment if you use these// Import the new search screen

// ignore: use_key_in_widget_constructors
class FindingYourDriverScreen extends StatefulWidget {
  const FindingYourDriverScreen({Key? key,
   this.selectedDriver, 
    this.rideBookingInfoFromResponse})
      : super(key: key);

  final NearestDriverData? selectedDriver;
  final RequestRideResponseModel ? rideBookingInfoFromResponse;


  @override
  State<FindingYourDriverScreen> createState() =>
      _FindingYourDriverScreenState();
}

class _FindingYourDriverScreenState extends State<FindingYourDriverScreen> {
  final LocationController locationController = Get.find<LocationController>();

  final BookingController bookingController = Get.find<BookingController>();

  final AppController appController = Get.find<AppController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Default to Dhaka, Bangladesh
    zoom: 14.0,
  );

  // Bottom sheet height control (fixed)
  static const double _sheetHeightFactor = 0.3; // adjust to resize fixed sheet

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to next screen after 3 seconds
      Get.to(
        () => RideConfirmedScreen(
          selectedDriver: widget.selectedDriver,
          rideBookingInfoFromResponse: widget.rideBookingInfoFromResponse,
        ),
      ); // Replace with your screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              locationController.setMapController(controller);
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
            polylines: locationController.polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (LatLng position) {
              locationController.setDestinationLocation(position);
            },
          ),
          // CONFIRM YOUR LOCATION BOTTOM SHEET
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height *
                  _sheetHeightFactor, // fixed height; tweak factor to change size
              padding: EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).padding.bottom + 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E38), // Dark grey from the image
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
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
                        onTap: () => Get.back(), // Go back to previous screen
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Text(
                        'Finding your driver...',
                        style: TextStyle(
                          color: Color(0xffEA0001),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 24), // For alignment
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B3B42), // Card background color
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
                                    color: Color(0xffEA0001),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 25, // Height for the connecting line
                                  color: Color(0xffEA0001),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'From:',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(

                                      locationController
                                              .pickupAddress
                                              .value
                                              .isEmpty
                                          ? 'Current Location'
                                          : locationController
                                                .pickupAddress
                                                .value,
                                      style: TextStyle(
                                        // overflow: TextOverflow.visible,
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
                          ],
                        ),
                        SizedBox(height: 20
                        
                        ), // Space between From and To
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
                                      color: Color(0xffEA0001),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'To:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        locationController
                                                .destinationAddress
                                                .value
                                                .isEmpty
                                            ? 'Select Destination' // Default text
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
                                // Only show distance if destination is set and distance is calculated
                                if (locationController
                                            .destinationLocation
                                            .value !=
                                        null &&
                                    locationController.distance.value > 0) {
                                  return Text(
                                    '${locationController.distance.value.toStringAsFixed(1)}km',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  );
                                }
                                return SizedBox.shrink(); // Hide if no destination or distance is zero
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // if (widget.selectedDriver != null)
                  //   Container(
                  //     padding: const EdgeInsets.all(14),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white10,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(8),
                  //           child: Image.network(
                  //             widget.selectedDriver!.service.serviceImage,
                  //             height: 60,
                  //             width: 80,
                  //             fit: BoxFit.cover,
                  //             errorBuilder: (_, __, ___) => Image.asset(
                  //               'assets/images/privet_car.png',
                  //               height: 60,
                  //               width: 80,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(width: 12),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 widget.selectedDriver!.service.name,
                  //                 style: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 "${widget.selectedDriver!.vehicle.taxiName} • Plate ${widget.selectedDriver!.vehicle.plateNumber}",
                  //                 style: const TextStyle(
                  //                   color: Colors.grey,
                  //                   fontSize: 13,
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 4),
                  //               Text(
                  //                 "Driver: ${widget.selectedDriver!.driver.userId.fullName}",
                  //                 style: const TextStyle(
                  //                   color: Colors.grey,
                  //                   fontSize: 12,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Text(
                  //           "${widget.selectedDriver!.service.estimatedArrivalTime} min",
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 14,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  SizedBox(height: 10),
                  // Confirm Location Button
                  // Container(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Action for "Confirm Location"
                  //       // For example, navigate to the next screen or trigger booking process
                  //       appController.setCurrentScreen(
                  //         'confirm',
                  //       ); // Your existing logic
                  //       // Get.to(() => LocationConfirmationScreen());
                  //       //  Get.to(() => RideConfirmedScreen());
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFFC0392B), // Red color
                  //       padding: EdgeInsets.symmetric(vertical: 15),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Confirm Location',
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
        ],
      ),
    );
  }
}








//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//         () => Stack(
//           children: [
//             GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 locationController.setMapController(controller);
//                 // Move camera to current location if available
//                 if (locationController.currentLocation.value != null) {
//                   controller.animateCamera(
//                     CameraUpdate.newLatLngZoom(
//                       locationController.currentLocation.value!,
//                       14.0,
//                     ),
//                   );
//                 }
//               },
//               initialCameraPosition: FindingYourDriverScreen._initialPosition,
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
//               top:
//                   MediaQuery.of(context).size.height *
//                   0.45, // Approximately center vertically
//               right: 20,
//               child: GestureDetector(
//                 onTap: () {
//                   // Re-center map on current location or destination
//                   if (locationController.currentLocation.value != null &&
//                       locationController.mapController.value != null) {
//                     locationController.mapController.value!.animateCamera(
//                       CameraUpdate.newLatLngZoom(
//                         locationController.currentLocation.value!,
//                         14.0,
//                       ),
//                     );
//                   }
//                 },
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.my_location, color: Colors.white, size: 30),
//                 ),
//               ),
//             ),

           

//             // Loading overlay
//             if (appController.isLoading.value)
//               Container(
//                 color: Colors.black54,
//                 child: Center(
//                   child: CircularProgressIndicator(color: Colors.red),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
