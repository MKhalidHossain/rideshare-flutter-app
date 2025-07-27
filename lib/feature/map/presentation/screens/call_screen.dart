import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../controllers/app_controller.dart';
import '../../controllers/booking_controller.dart';
import 'chat_screen.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AppController appController = Get.find<AppController>();
  final BookingController bookingController = Get.find<BookingController>();
  
  Timer? _callTimer;
  int _callDuration = 0;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isCallActive = true;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  String _formatCallDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with back button and call info
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                    onPressed: () => Get.back(),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        _isCallActive ? 'Calling...' : 'Call Ended',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatCallDuration(_callDuration),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            
            Spacer(),
            
            // Driver/Contact Info
            Obx(() => Column(
              children: [
                // Profile Picture
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.grey[700],
                    child: bookingController.driver.value != null
                      ? Text(
                          bookingController.driver.value!.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(Icons.person, color: Colors.white, size: 60),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Name
                Text(
                  bookingController.driver.value?.name ?? 'Sergio Ramasis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 8),
                
                // Phone number or status
                Text(
                  bookingController.driver.value?.phone ?? '+1 (555) 123-4567',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Car info
                if (bookingController.driver.value != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bookingController.driver.value!.carModel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            )),
            
            Spacer(),
            
            // Call Controls
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute button
                  _buildCallButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    backgroundColor: _isMuted ? Colors.red : Colors.grey[700]!,
                    onPressed: () {
                      setState(() {
                        _isMuted = !_isMuted;
                      });
                      appController.showSnackbar(
                        'Info', 
                        _isMuted ? 'Microphone muted' : 'Microphone unmuted'
                      );
                    },
                  ),
                  
                  // End call button
                  _buildCallButton(
                    icon: Icons.call_end,
                    backgroundColor: Colors.red,
                    size: 70,
                    iconSize: 35,
                    onPressed: () {
                      setState(() {
                        _isCallActive = false;
                      });
                      _callTimer?.cancel();
                      appController.showSnackbar('Info', 'Call ended');
                      
                      // Navigate back after a short delay
                      Future.delayed(Duration(seconds: 1), () {
                        Get.back();
                      });
                    },
                  ),
                  
                  // Speaker button
                  _buildCallButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    backgroundColor: _isSpeakerOn ? Colors.blue : Colors.grey[700]!,
                    onPressed: () {
                      setState(() {
                        _isSpeakerOn = !_isSpeakerOn;
                      });
                      appController.showSnackbar(
                        'Info', 
                        _isSpeakerOn ? 'Speaker on' : 'Speaker off'
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Additional controls
            Container(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Chat button
                  _buildSecondaryButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    onPressed: () => Get.to(() => ChatScreen()),
                  ),
                  
                  // Keypad button
                  _buildSecondaryButton(
                    icon: Icons.dialpad,
                    label: 'Keypad',
                    onPressed: () => appController.showSnackbar('Info', 'Keypad feature coming soon!'),
                  ),
                  
                  // Add call button
                  _buildSecondaryButton(
                    icon: Icons.person_add,
                    label: 'Add',
                    onPressed: () => appController.showSnackbar('Info', 'Add call feature coming soon!'),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
    double size = 60,
    double iconSize = 30,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}