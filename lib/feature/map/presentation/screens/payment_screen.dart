import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import 'chat_screen.dart';

class PaymentScreen extends StatelessWidget {
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        title: Text('Payment Method'),
        backgroundColor: Color(0xFF2C3E50),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary
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
                    'Trip Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Base Fare',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text(
                        '\$8.50',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Distance',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text(
                        '\$3.16',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text(
                        '\$1.00',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey, height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            Text(
              'Payment Methods',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Payment Methods List
            Expanded(
              child: ListView(
                children: [
                  _buildPaymentMethodTile(
                    icon: Icons.money,
                    title: 'Cash',
                    subtitle: 'Pay with cash',
                    isSelected: bookingController.selectedPaymentMethod.value == 'Cash',
                    onTap: () => bookingController.selectPaymentMethod('Cash'),
                  ),
                  _buildPaymentMethodTile(
                    icon: Icons.account_balance_wallet,
                    title: 'Wallet',
                    subtitle: 'Balance: \$45.20',
                    isSelected: bookingController.selectedPaymentMethod.value == 'Wallet',
                    onTap: () => bookingController.selectPaymentMethod('Wallet'),
                  ),
                  _buildPaymentMethodTile(
                    icon: Icons.credit_card,
                    title: 'Credit Card',
                    subtitle: '**** **** **** 1234',
                    isSelected: bookingController.selectedPaymentMethod.value == 'Credit Card',
                    onTap: () => bookingController.selectPaymentMethod('Credit Card'),
                  ),
                  _buildPaymentMethodTile(
                    icon: Icons.add,
                    title: 'Add Payment Method',
                    subtitle: 'Add a new payment method',
                    isSelected: false,
                    onTap: () => Get.snackbar('Info', 'Add payment method feature coming soon!'),
                  ),
                ],
              ),
            ),
            
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
                          'Support',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      appController.showSnackbar(
                        'Success', 
                        'Payment method updated to ${bookingController.selectedPaymentMethod.value}'
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm Payment',
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
      )),
    );
  }

  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF34495E),
          borderRadius: BorderRadius.circular(12),
          border: isSelected 
            ? Border.all(color: Colors.red, width: 2)
            : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.red, size: 24),
          ],
        ),
      ),
    );
  }
}