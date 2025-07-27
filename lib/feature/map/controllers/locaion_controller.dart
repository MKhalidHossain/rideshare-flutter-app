import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  // Location state
  var currentPosition = Rxn<Position>();
  var pickupLocation = Rxn<LatLng>();
  var destinationLocation = Rxn<LatLng>();
  var pickupAddress = ''.obs;
  var destinationAddress = ''.obs;
  
  // Map state
  var mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var isLocationPermissionGranted = false.obs;
  
  // Search state
  var searchResults = <String>[].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  
  // Saved locations
  var homeAddress = '1234 Elm Street, City, State 12345'.obs;
  var workAddress = '5678 Oak Avenue, City, State 67890'.obs;
  var favoriteAddress = '9012 Pine Road, City, State 34567'.obs;
  
  @override
  void onInit() {
    super.onInit();
    requestLocationPermission();
    getCurrentLocation();
  }
  
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    isLocationPermissionGranted.value = 
        permission == LocationPermission.whileInUse || 
        permission == LocationPermission.always;
  }
  
  Future<void> getCurrentLocation() async {
    try {
      if (isLocationPermissionGranted.value) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        currentPosition.value = position;
        pickupLocation.value = LatLng(position.latitude, position.longitude);
        await getAddressFromCoordinates(position.latitude, position.longitude, true);
        updateMapMarkers();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }
  
  Future<void> getAddressFromCoordinates(double lat, double lng, bool isPickup) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
        
        if (isPickup) {
          pickupAddress.value = address;
        } else {
          destinationAddress.value = address;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get address: $e');
    }
  }
  
  void setPickupLocation(LatLng location) {
    pickupLocation.value = location;
    getAddressFromCoordinates(location.latitude, location.longitude, true);
    updateMapMarkers();
  }
  
  void setDestinationLocation(LatLng location) {
    destinationLocation.value = location;
    getAddressFromCoordinates(location.latitude, location.longitude, false);
    updateMapMarkers();
  }
  
  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
  }
  
  void updateMapMarkers() {
    markers.clear();
    
    if (pickupLocation.value != null) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: pickupLocation.value!,
          infoWindow: InfoWindow(title: 'Pickup Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    
    if (destinationLocation.value != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: destinationLocation.value!,
          infoWindow: InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }
  
  void searchLocation(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    
    isSearching.value = true;
    
    // Simulate search results - replace with actual API call
    Future.delayed(Duration(milliseconds: 500), () {
      searchResults.value = [
        '$query - Main Street',
        '$query - Downtown',
        '$query - City Center',
        '$query - Shopping Mall',
        '$query - Airport',
      ];
      isSearching.value = false;
    });
  }
  
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }
  
  void selectSearchResult(int index) {
    destinationAddress.value = searchResults[index];
    searchResults.clear();
  }
  
  void selectSavedLocation(String type) {
    switch (type) {
      case 'home':
        destinationAddress.value = homeAddress.value;
        break;
      case 'work':
        destinationAddress.value = workAddress.value;
        break;
      case 'favorite':
        destinationAddress.value = favoriteAddress.value;
        break;
    }
  }
}