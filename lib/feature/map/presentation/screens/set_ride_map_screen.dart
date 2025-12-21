import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/locaion_controller.dart';

class SetRideMapScreen extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125), // Default to Dhaka
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
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
                // Polyline and distance will update automatically
              },
            ),

            // Back button (top left)
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
            // My location button (red target icon)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors
                    .red, // Changed to red for consistency with screenshot
                onPressed: () {
                  if (locationController.currentLocation.value != null &&
                      locationController.mapController.value != null) {
                    locationController.mapController.value!.animateCamera(
                      CameraUpdate.newLatLngZoom(
                        locationController.currentLocation.value!,
                        14.0,
                      ),
                    );
                  } else {
                    locationController
                        .getCurrentLocation(); // Attempt to get current location if not available
                  }
                },
                child: Icon(Icons.my_location, color: Colors.white),
              ),
            ),

            // SET RIDE BOTTOM SHEET
            Positioned(
              bottom: 0, // Position at the very bottom
              left: 0,
              right: 0,
              child: Container(
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
                          onTap: () => Get.back(), // Go back to search screen
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Text(
                          'Set Ride',
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
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF3B3B42,
                        ), // Slightly lighter dark grey
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/copen_gr_sport.png', // Replace with your actual image path
                            width: 80,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookingController
                                      .getCarTypeString(), // Assuming this exists in your bookingController
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Affordable rides for everyday', // Static text from screenshot
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(
                                () => Text(
                                  '\$${bookingController.estimatedPrice.value.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Obx(
                                () => Text(
                                  '${bookingController.estimatedTime.value} min away',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action for "Choose car"
                          // This button will likely lead to the "Confirm your location" screen
                         // Get.to(() => ConfirmLocationMapScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC0392B), // Red color
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Choose car',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            Obx(
              () => appController.isLoading.value
                  ? Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
