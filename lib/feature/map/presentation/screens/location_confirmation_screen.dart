import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/locaion_controller.dart';
import 'chat_screen.dart';
import 'call_screen.dart';
import 'payment_screen.dart';
import 'map_screen.dart';

class LocationConfirmationScreen extends StatelessWidget {
  final LocationController locationController = Get.find<LocationController>();
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text('Confirm Location'),
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
        ],
      ),
      body: Obx(() => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Details
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF34495E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildLocationRow(
                    icon: Icons.radio_button_checked,
                    iconColor: Colors.green,
                    title: 'Pickup Location',
                    address: locationController.pickupAddress.value.isEmpty 
                      ? '4140 Parker Rd, Allentown, New Mexico 31134' 
                      : locationController.pickupAddress.value,
                  ),
                  SizedBox(height: 12),
                  _buildLocationRow(
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    title: 'Destination',
                    address: locationController.destinationAddress.value.isEmpty 
                      ? '4140 Parker Rd, Allentown, New Mexico 31134' 
                      : locationController.destinationAddress.value,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Car and Driver Info
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF34495E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
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
                      SizedBox(width: 16),
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
                              'Estimated arrival: ${bookingController.estimatedTime.value} min',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${bookingController.estimatedPrice.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Estimated fare',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Payment Method
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF34495E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.payment, color: Colors.white),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          bookingController.selectedPaymentMethod.value,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => PaymentScreen()),
                    child: Text(
                      'Change',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            
            Spacer(),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => ChatScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF34495E),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => CallScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF34495E),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Call',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: appController.isLoading.value 
                  ? null 
                  : () {
                      bookingController.confirmBooking();
                      appController.showSnackbar(
                        'Success', 
                        'Your ride has been confirmed!'
                      );
                      // Navigate back to map screen
                      Get.offAll(() => MapScreen());
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: appController.isLoading.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Confirm Ride',
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
      )),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                address,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}