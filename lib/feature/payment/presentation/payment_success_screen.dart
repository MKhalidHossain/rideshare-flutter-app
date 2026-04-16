import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/core/extensions/text_extensions.dart';
import 'package:rideztohealth/feature/home/presentation/screens/home_screen.dart';

import '../../home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String? sessionId;
  final NearestDriverData? selectedDriver;

  const PaymentSuccessScreen({
    super.key,
    this.sessionId,
    this.selectedDriver,
  });

  @override
  Widget build(BuildContext context) {
    final driverName = selectedDriver?.driver.userId?.fullName;
    return Scaffold(
      appBar: AppBar(
        title: "Payment Successful".text14White500(),
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(onPressed: () => Get.back(result: true)),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 96,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your payment was successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (driverName != null && driverName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Driver: $driverName',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
                if (sessionId != null && sessionId!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Session: $sessionId',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAll(() => const HomeScreen()),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
