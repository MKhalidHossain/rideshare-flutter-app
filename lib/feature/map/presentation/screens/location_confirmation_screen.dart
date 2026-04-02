import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/widgets/shimmer/shimmer_skeleton.dart';

import '../../../../helpers/custom_snackbar.dart';
import '../../controllers/locaion_controller.dart';
import '../../controllers/booking_controller.dart'; // Assuming bookingController holds price/time
import '../../controllers/app_controller.dart'; // Import the search screen

class LocationConfirmationScreen extends StatelessWidget {
  const LocationConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController =
        Get.find<LocationController>();
    final BookingController bookingController = Get.find<BookingController>();
    final AppController appController = Get.find<AppController>();

    return Scaffold(
      backgroundColor: const Color(0xFF2E2E38), // Match the dark background
      appBar: AppBar(
        title: const Text(
          'Confirm your location',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E2E38), // Dark background color
        leading: BackButton(color: Colors.white, onPressed: () => Get.back()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Location Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(
                  0xFF3B3B42,
                ), // Darker background for the card
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "From" Location Row
                  GestureDetector(
                    onTap: () async {
                      // UNCOMMENTED: Navigate to search screen for pickup location
                      //  await Get.to(() => DestinationSearchScreen(isPickup: true));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green, // Green for pickup
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Obx(
                                () => Text(
                                  locationController.pickupAddress.value.isEmpty
                                      ? 'Select Pickup Location'
                                      : locationController.pickupAddress.value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
                  ),
                  // Vertical line connecting the "From" and "To" dots.
                  Container(
                    margin: const EdgeInsets.only(left: 4.5),
                    height: 24,
                    width: 1.5,
                    color: Colors.red, // Red color for the line
                  ),
                  // "To" Location Row
                  GestureDetector(
                    onTap: () async {
                      // UNCOMMENTED: Navigate to search screen for destination location
                      // await Get.to(() => DestinationSearchScreen(isPickup: false));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red, // Red for destination
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
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
                                      ? 'Select Destination'
                                      : locationController
                                            .destinationAddress
                                            .value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Distance text on the right side.
                        Obx(() {
                          if (locationController.distance.value > 0) {
                            return Text(
                              '${locationController.distance.value.toStringAsFixed(1)} Miles',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Estimated Fare (Example, from bookingController)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3B3B42),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estimated Fare:',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Obx(
                    () => Text(
                      '\$${bookingController.estimatedPrice.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(), // Pushes the "Confirm Location" button to the bottom.
            // Confirm Location Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: appController.isLoading.value
                    ? null
                    : () {
                        // Ensure both pickup and destination are selected before confirming
                        if (locationController.pickupLocation.value == null ||
                            locationController.destinationLocation.value ==
                                null) {
                          showAppSnackBar(
                            'Error',
                            'Please select both pickup and destination locations.',
                            isError: true,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        // This is a placeholder for the button's action.
                        // You would typically handle navigation or data confirmation here.
                        appController.showLoading(); // Corrected method call
                        Future.delayed(Duration(seconds: 2), () {
                          appController.hideLoading(); // Corrected method call
                          //  Get.to(() => RideConfirmedScreen()); // Navigate to ride confirmed screen
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Obx(
                  () => appController.isLoading.value
                      ? const ShimmerBox(
                          width: 120,
                          height: 16,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )
                      : const Text(
                          'Confirm Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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

class DestinationSearchScreen {}

// class DestinationSearchScreen extends StatelessWidget {
//   final LocationController locationController = Get.find<LocationController>();
//   final bool isPickup; // <--- This is crucial

//   DestinationSearchScreen({Key? key, this.isPickup = false}) : super(key: key);
//   // ... (rest of the code)
//   onTap: () {
//       locationController.selectSearchResult(address, isPickup: isPickup); // <--- Pass the flag
//       Get.back();
//   },
//   // ... similarly for selectSavedLocation
// }

// class LocationController extends GetxController {
//   // ...
//   var pickupLocation = Rxn<LatLng>();
//   var destinationLocation = Rxn<LatLng>();
//   var polylines = <Polyline>{}.obs; // <--- Crucial for map updates
//   var distance = 0.0.obs; // <--- For distance display
//   // ...
//   void selectSearchResult(String address, {required bool isPickup}) async { // <--- isPickup param
//     // ...
//     if (isPickup) {
//       setPickupLocation(LatLng(locations.first.latitude, locations.first.longitude));
//     } else {
//       setDestinationLocation(LatLng(locations.first.latitude, locations.first.longitude));
//     }
//   }
//   // ... similarly for selectSavedLocation
// }

// import 'package:flutter/material.dart';

// // This screen is designed to match the provided screenshot for confirming location.
// // It includes an app bar, a location details card with "From" and "To" addresses,
// // and a "Confirm Location" button at the bottom.
// // The design replicates the dots and connecting line visually.
// class LocationConfirmationScreen extends StatelessWidget {
//   const LocationConfirmationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // AppBar for the screen, matching the dark background and white text/icons from the image.
//       appBar: AppBar(
//         title: const Text(
//           'Confirm your location',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xFF2C3E50), // Dark background color
//         leading: BackButton(color: Colors.white),
//       ),
//       // The body contains the main content, with padding around the edges.
//       body: Padding(
//         padding: const EdgeInsets.all(
//           20.0,
//         ), // Overall padding for the screen content
//         child: Column(
//           children: [
//             // Location Info Card: This container holds the "From" and "To" address details.
//             Container(
//               padding: const EdgeInsets.all(
//                 16,
//               ), // Inner padding for the card content
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2C3E50), // Dark background for the card
//                 borderRadius: BorderRadius.circular(
//                   12,
//                 ), // Rounded corners for the card
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment
//                     .start, // Align content to the start (left)
//                 children: [
//                   // "From" Location Row
//                   Row(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start, // Align items to the top
//                     children: [
//                       // Green dot for "From" location, matching the screenshot.
//                       Container(
//                         margin: const EdgeInsets.only(
//                           top: 4,
//                         ), // Adjust to vertically align with text
//                         width: 10, // Diameter of the dot
//                         height: 10, // Diameter of the dot
//                         decoration: const BoxDecoration(
//                           color: Colors.green, // Green color for the dot
//                           shape: BoxShape.circle, // Circular shape
//                         ),
//                       ),
//                       const SizedBox(width: 10), // Spacing between dot and text
//                       // Text details for "From" location
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'From:',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ), // Smaller, grey "From" label
//                             ),
//                             Text(
//                               'Current Location', // Placeholder for current location
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ), // White text for location
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Vertical line connecting the "From" and "To" dots.
//                   Container(
//                     // Margin adjusted to visually center the line with the dots.
//                     // Calculation: (dot_width / 2) - (line_width / 2) = (10 / 2) - (1.5 / 2) = 5 - 0.75 = 4.25
//                     // Using 4.5 for visual alignment.
//                     margin: const EdgeInsets.only(left: 4.5),
//                     height: 24, // Length of the line
//                     width: 1.5, // Thickness of the line
//                     color: Colors
//                         .red, // Red color for the line, matching the screenshot
//                   ),
//                   // "To" Location Row
//                   Row(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start, // Align items to the top
//                     children: [
//                       // Red dot for "To" location, matching the screenshot.
//                       Container(
//                         margin: const EdgeInsets.only(
//                           top: 4,
//                         ), // Adjust to vertically align with text
//                         width: 10, // Diameter of the dot
//                         height: 10, // Diameter of the dot
//                         decoration: const BoxDecoration(
//                           color: Colors.red, // Red color for the dot
//                           shape: BoxShape.circle, // Circular shape
//                         ),
//                       ),
//                       const SizedBox(width: 10), // Spacing between dot and text
//                       // Text details for "To" location
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'To:',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ), // Smaller, grey "To" label
//                             ),
//                             Text(
//                               '4140 Parker Rd. Allentown, New Mexico 31134', // Placeholder for destination address
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                               ), // White text for address
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Distance text on the right side.
//                       const Text(
//                         '4.0 miles', // Placeholder for distance
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ), // White text for distance
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(), // Pushes the "Confirm Location" button to the bottom of the screen.
//             // Confirm Location Button
//             ElevatedButton(
//               onPressed: () {
//                 // This is a placeholder for the button's action.
//                 // You would typically handle navigation or data confirmation here.
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red, // Red background for the button
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 16,
//                 ), // Vertical padding for the button text
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(
//                     8,
//                   ), // Rounded corners for the button
//                 ),
//                 minimumSize: const Size(
//                   double.infinity,
//                   50,
//                 ), // Makes the button full width
//               ),
//               child: const Text(
//                 'Confirm Location',
//                 style: TextStyle(
//                   color: Colors.white, // White text for the button
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold, // Bold text
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/app_controller.dart';
// import '../../controllers/booking_controller.dart';
// import '../../controllers/locaion_controller.dart';
// import 'chat_screen.dart';
// import 'call_screen.dart';
// import 'payment_screen.dart';
// import 'map_screen.dart';

// class LocationConfirmationScreen extends StatelessWidget {
//   final LocationController locationController = Get.find<LocationController>();
//   final BookingController bookingController = Get.find<BookingController>();
//   final AppController appController = Get.find<AppController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF2C3E50),
//       appBar: AppBar(
//         title: Text('Confirm Location'),
//         backgroundColor: Color(0xFF2C3E50),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.chat),
//             onPressed: () => Get.to(() => ChatScreen()),
//           ),
//         ],
//       ),
//       body: Obx(() => Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Location Details
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Color(0xFF34495E),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Trip Details',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   _buildLocationRow(
//                     icon: Icons.radio_button_checked,
//                     iconColor: Colors.green,
//                     title: 'Pickup Location',
//                     address: locationController.pickupAddress.value.isEmpty
//                       ? '4140 Parker Rd, Allentown, New Mexico 31134'
//                       : locationController.pickupAddress.value,
//                   ),
//                   SizedBox(height: 12),
//                   _buildLocationRow(
//                     icon: Icons.location_on,
//                     iconColor: Colors.red,
//                     title: 'Destination',
//                     address: locationController.destinationAddress.value.isEmpty
//                       ? '4140 Parker Rd, Allentown, New Mexico 31134'
//                       : locationController.destinationAddress.value,
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 20),

//             // Car and Driver Info
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Color(0xFF34495E),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Vehicle Information',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Container(
//                         width: 60,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Colors.orange,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.directions_car, color: Colors.white),
//                       ),
//                       SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               bookingController.getCarTypeString(),
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Estimated arrival: ${bookingController.estimatedTime.value} min',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             '\$${bookingController.estimatedPrice.value.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             'Estimated fare',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 20),

//             // Payment Method
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Color(0xFF34495E),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.payment, color: Colors.white),
//                   SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Payment Method',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           bookingController.selectedPaymentMethod.value,
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () => Get.to(() => PaymentScreen()),
//                     child: Text(
//                       'Change',
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Spacer(),

//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Get.to(() => ChatScreen()),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF34495E),
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.chat, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text(
//                           'Chat',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => Get.to(() => CallScreen()),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF34495E),
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.call, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text(
//                           'Call',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 16),

//             // Confirm Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: appController.isLoading.value
//                   ? null
//                   : () {
//                       bookingController.confirmBooking();
//                       appController.showSnackbar(
//                         'Success',
//                         'Your ride has been confirmed!'
//                       );
//                       // Navigate back to map screen
//                       Get.offAll(() => MapScreen());
//                     },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: appController.isLoading.value
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text(
//                       'Confirm Ride',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }

//   Widget _buildLocationRow({
//     required IconData icon,
//     required Color iconColor,
//     required String title,
//     required String address,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: iconColor, size: 20),
//         SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 address,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
