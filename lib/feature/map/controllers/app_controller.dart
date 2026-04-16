import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../helpers/custom_snackbar.dart';

class AppController extends GetxController {
  // User information
  var userName = 'John Doe'.obs;
  var userEmail = 'john.doe@example.com'.obs;
  var userPhone = '+1 (555) 123-4567'.obs;
  
  // App state
  var isLoading = false.obs;
  var currentScreen = 'search'.obs;
  var isOnline = true.obs;
  
  // Theme and UI state
  var isDarkMode = true.obs;
  var selectedLanguage = 'English'.obs;
  
  // Notification settings
  var notificationsEnabled = true.obs;
  var soundEnabled = true.obs;
  var vibrationEnabled = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize app state
    checkConnectivity();
  }
  
  // Loading state management
  void setLoading(bool loading) {
    isLoading.value = loading;
  }
  
  void showLoading() {
    isLoading.value = true;
  }
  
  void hideLoading() {
    isLoading.value = false;
  }
  
  // Screen navigation tracking
  void setCurrentScreen(String screen) {
    currentScreen.value = screen;
  }
  
  // User management
  void updateUserInfo({
    String? name,
    String? email,
    String? phone,
  }) {
    if (name != null) userName.value = name;
    if (email != null) userEmail.value = email;
    if (phone != null) userPhone.value = phone;
  }
  
  // Connectivity
  void checkConnectivity() {
    // Simulate connectivity check
    Future.delayed(Duration(seconds: 2), () {
      isOnline.value = true;
    });
  }
  
  void setOnlineStatus(bool status) {
    isOnline.value = status;
  }
  
  // Theme management
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
  
  void setTheme(bool dark) {
    isDarkMode.value = dark;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }
  
  // Language management
  void setLanguage(String language) {
    selectedLanguage.value = language;
    // Here you would typically update the app's locale
  }
  
  // Notification settings
  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }
  
  void toggleSound() {
    soundEnabled.value = !soundEnabled.value;
  }
  
  void toggleVibration() {
    vibrationEnabled.value = !vibrationEnabled.value;
  }
  
  // Utility methods
  void showSnackbar(String title, String message, {Color? backgroundColor}) {
    showAppSnackBar(
      title,
      message,
      isError: false,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void showSuccessSnackbar(String message) {
    showAppSnackBar(
      'Success',
      message,
      isError: false,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void showErrorSnackbar(String message) {
    showAppSnackBar(
      'Error',
      message,
      isError: true,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void showInfoSnackbar(String message) {
    showAppSnackBar(
      'Info',
      message,
      isError: false,
      backgroundColor: Colors.blue,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Dialog helpers
  void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF34495E),
        title: Text(title, style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: onCancel ?? () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  
  // Emergency features
  void callEmergency() {
    showSnackbar('Emergency', 'Calling emergency services...');
    // Here you would implement actual emergency calling
  }
  
  void shareLocation() {
    showSnackbar('Location', 'Sharing your location...');
    // Here you would implement location sharing
  }
  
  // App lifecycle
  void onAppPaused() {
    // Handle app being paused
  }
  
  void onAppResumed() {
    // Handle app being resumed
    checkConnectivity();
  }
}
