import 'package:get/get.dart';
import '../domain/models/booking.dart';
import '../domain/models/driver.dart';

enum CarType { economy, comfort, premium, luxury }
enum BookingStatus { searching, confirmed, driverAssigned, inProgress, completed, cancelled }

class BookingController extends GetxController {
  // Booking state
  var currentBooking = Rxn<Booking>();
  var bookingStatus = BookingStatus.searching.obs;
  var driver = Rxn<Driver>();
  
  // Car selection
  var selectedCarType = CarType.economy.obs;
  var availableCarTypes = <CarType>[].obs;
  
  // Pricing and timing
  var estimatedPrice = 12.66.obs;
  var estimatedTime = 5.obs;
  var actualPrice = 0.0.obs;
  var tripDuration = 0.obs;
  
  // Payment
  var selectedPaymentMethod = 'Cash'.obs;
  var availablePaymentMethods = <String>[].obs;
  
  // Trip tracking
  var isRideActive = false.obs;
  var tripStartTime = Rxn<DateTime>();
  var tripEndTime = Rxn<DateTime>();
  var tripDistance = 0.0.obs;
  
  // Driver tracking
  var driverLocation = Rxn<String>();
  var driverETA = 0.obs;
  var driverRating = 0.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    initializeBookingData();
  }
  
  void initializeBookingData() {
    // Initialize available car types
    availableCarTypes.value = CarType.values;
    
    // Initialize payment methods
    availablePaymentMethods.value = [
      'Cash',
      'Credit Card',
      'Debit Card',
      'Wallet',
      'PayPal',
      'Apple Pay',
      'Google Pay',
    ];
    
    // Set default values
    selectedCarType.value = CarType.economy;
    selectedPaymentMethod.value = 'Cash';
    
    // Simulate price calculation
    calculateEstimatedPrice();
  }
  
  // Car type management
  void selectCarType(CarType carType) {
    selectedCarType.value = carType;
    calculateEstimatedPrice();
    calculateEstimatedTime();
  }
  
  String getCarTypeString() {
    switch (selectedCarType.value) {
      case CarType.economy:
        return 'Economy';
      case CarType.comfort:
        return 'Comfort';
      case CarType.premium:
        return 'Premium';
      case CarType.luxury:
        return 'Luxury';
    }
  }
  
  String getCarTypeDescription() {
    switch (selectedCarType.value) {
      case CarType.economy:
        return 'Affordable rides for everyday trips';
      case CarType.comfort:
        return 'More space and comfort for your journey';
      case CarType.premium:
        return 'High-end vehicles with premium features';
      case CarType.luxury:
        return 'Luxury vehicles for special occasions';
    }
  }
  
  // Price calculation
  void calculateEstimatedPrice() {
    double basePrice = 8.50;
    double multiplier = 1.0;
    
    switch (selectedCarType.value) {
      case CarType.economy:
        multiplier = 1.0;
        break;
      case CarType.comfort:
        multiplier = 1.3;
        break;
      case CarType.premium:
        multiplier = 1.8;
        break;
      case CarType.luxury:
        multiplier = 2.5;
        break;
    }
    
    estimatedPrice.value = basePrice * multiplier;
  }
  
  void calculateEstimatedTime() {
    int baseTime = 5;
    
    switch (selectedCarType.value) {
      case CarType.economy:
        estimatedTime.value = baseTime;
        break;
      case CarType.comfort:
        estimatedTime.value = baseTime + 2;
        break;
      case CarType.premium:
        estimatedTime.value = baseTime + 3;
        break;
      case CarType.luxury:
        estimatedTime.value = baseTime + 5;
        break;
    }
  }
  
  // Payment management
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
  
  // Booking management
  void createBooking({
    required String pickupAddress,
    required String destinationAddress,
  }) {
    currentBooking.value = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      carType: selectedCarType.value,
      paymentMethod: selectedPaymentMethod.value,
      estimatedPrice: estimatedPrice.value,
      status: BookingStatus.searching,
      createdAt: DateTime.now(),
    );
    
    bookingStatus.value = BookingStatus.searching;
    searchForDriver();
  }
  
  void confirmBooking() {
    if (currentBooking.value != null) {
      bookingStatus.value = BookingStatus.confirmed;
      assignDriver();
    }
  }
  
  void searchForDriver() {
    bookingStatus.value = BookingStatus.searching;
    
    // Simulate driver search
    Future.delayed(Duration(seconds: 3), () {
      assignDriver();
    });
  }
  
  void assignDriver() {
    // Simulate driver assignment
    driver.value = Driver(
      id: '1',
      name: 'Sergio Ramasis',
      phone: '+1 (555) 123-4567',
      rating: 4.8,
      carModel: 'Toyota Camry',
      carColor: 'White',
      licensePlate: 'ABC-123',
      profileImage: '',
    );
    
    bookingStatus.value = BookingStatus.driverAssigned;
    driverETA.value = estimatedTime.value;
    driverRating.value = driver.value!.rating;
  }
  
  void startTrip() {
    isRideActive.value = true;
    tripStartTime.value = DateTime.now();
    bookingStatus.value = BookingStatus.inProgress;
  }
  
  void endTrip() {
    isRideActive.value = false;
    tripEndTime.value = DateTime.now();
    bookingStatus.value = BookingStatus.completed;
    
    if (tripStartTime.value != null && tripEndTime.value != null) {
      tripDuration.value = tripEndTime.value!
          .difference(tripStartTime.value!)
          .inMinutes;
    }
    
    calculateActualPrice();
  }
  
  void cancelBooking() {
    bookingStatus.value = BookingStatus.cancelled;
    currentBooking.value = null;
    driver.value = null;
    isRideActive.value = false;
  }
  
  void calculateActualPrice() {
    // Calculate actual price based on time and distance
    double timePrice = tripDuration.value * 0.5;
    double distancePrice = tripDistance.value * 1.2;
    actualPrice.value = estimatedPrice.value + timePrice + distancePrice;
  }
  
  // Driver interaction
  void rateDriver(double rating) {
    if (driver.value != null) {
      // Here you would send the rating to your backend
      Get.snackbar('Thank you!', 'Your rating has been submitted');
    }
  }
  
  void reportDriver(String reason) {
    if (driver.value != null) {
      // Here you would send the report to your backend
      Get.snackbar('Report Submitted', 'Thank you for your feedback');
    }
  }
  
  // Utility methods
  String getBookingStatusString() {
    switch (bookingStatus.value) {
      case BookingStatus.searching:
        return 'Searching for driver...';
      case BookingStatus.confirmed:
        return 'Booking confirmed';
      case BookingStatus.driverAssigned:
        return 'Driver assigned';
      case BookingStatus.inProgress:
        return 'Trip in progress';
      case BookingStatus.completed:
        return 'Trip completed';
      case BookingStatus.cancelled:
        return 'Booking cancelled';
    }
  }
  
  bool canCancelBooking() {
    return bookingStatus.value == BookingStatus.searching ||
           bookingStatus.value == BookingStatus.confirmed ||
           bookingStatus.value == BookingStatus.driverAssigned;
  }
  
  bool isDriverAssigned() {
    return driver.value != null;
  }
  
  // Emergency features
  void callEmergency() {
    Get.snackbar('Emergency', 'Calling emergency services...');
    // Implement emergency calling
  }
  
  void shareLocationWithEmergencyContact() {
    Get.snackbar('Location Shared', 'Your location has been shared with emergency contacts');
    // Implement location sharing
  }
}