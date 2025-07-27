import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/locaion_controller.dart';
import 'location_confirmation_screen.dart';
import 'chat_screen.dart';
import 'call_screen.dart';
import 'payment_screen.dart';

class MapScreen extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Color(0xFF2C3E50),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () => Get.to(() => ChatScreen()),
          ),
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () => Get.to(() => CallScreen()),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              locationController.setMapController(controller);
            },
            initialCameraPosition: _initialPosition,
            markers: locationController.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (LatLng position) {
              locationController.setDestinationLocation(position);
            },
          ),
          
          // Top location info
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locationController.pickupAddress.value.isEmpty 
                            ? 'Current Location' 
                            : locationController.pickupAddress.value,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locationController.destinationAddress.value.isEmpty 
                            ? 'Select destination' 
                            : locationController.destinationAddress.value,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Car selection bottom sheet
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2C3E50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.directions_car, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookingController.getCarTypeString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${bookingController.estimatedTime.value} min away',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${bookingController.estimatedPrice.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => PaymentScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF34495E),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Payment',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            appController.setCurrentScreen('confirm');
                            Get.to(() => LocationConfirmationScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Confirm Location',
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
                ],
              ),
            ),
          ),

          // My location button
          Positioned(
            top: 100,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () => locationController.getCurrentLocation(),
              child: Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // Loading overlay
          if (appController.isLoading.value)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
        ],
      )),
    );
  }
}