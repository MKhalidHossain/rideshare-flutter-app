import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideztohealth/feature/map/controllers/locaion_controller.dart';

import '../../../core/constants/app_constant.dart';
import '../domain/models/place_prediction.dart';
import '../service/location_service_interface.dart';

class LocationPickedController extends GetxController implements GetxService {
  final LocationServiceInterface locationServiceInterface =
      Get.find<LocationServiceInterface>();

  bool isLoading = false;

  RxList<PlacePrediction> autoCompliteSuggetion = RxList<PlacePrediction>();
  final Dio _dio = Dio();

  //  Future<void> searchChanged(String query) async {
  //   try {
  //     isLoading = true;
  //     update();

  //     final response = await locationServiceInterface
  //         .searchPlaces(query: query);
  //         autoCompliteSuggetion.value = response;

  //   } catch (e) {
  //     print("⚠️ Error from Location Picked Controller : searchChanged : $e\n");
  //   } finally {
  //     isLoading = false;
  //     update();
  //   }
  // }

  // lib/feature/map/controllers/location_picked_controller.dart

  Future<void> searchChanged(String query) async {
    if (query.trim().length < 2) {
      // Too short, clear list
      autoCompliteSuggetion.clear();
      update();
      return;
    }

    try {
      isLoading = true;
      update();

      // Optional: bias results around current GPS
      final locController = Get.find<LocationController>();
      final current = locController.currentLocation.value;

      final Map<String, dynamic> params = {
        'input': query,
        'key': AppConstant.apiKey,
        'language': 'en',
        // 🔹 Only US + Bangladesh results
        'components': 'country:bd|country:us',
      };

      if (current != null) {
        params['location'] = '${current.latitude},${current.longitude}';
        params['radius'] = '50000'; // ~31 miles bias
      }

      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: params,
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final List predictions = response.data['predictions'] ?? [];

        autoCompliteSuggetion.value = predictions
            .map<PlacePrediction>((p) => PlacePrediction.fromJson(p))
            .toList();
      } else {
        debugPrint(
          'Places API error: ${response.data['status']} - ${response.data['error_message']}',
        );
        autoCompliteSuggetion.clear();
      }
    } catch (e) {
      debugPrint("⚠️ Error from LocationPickedController.searchChanged: $e");
      autoCompliteSuggetion.clear();
    } finally {
      isLoading = false;
      update();
    }
  }

  // Method to get place details including lat/lng from place_id
  Future<LatLng?> getPlaceDetails(String placeId) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&fields=geometry'
          '&key=${AppConstant.apiKey}';

      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        print('Place Details API Error: ${response.data['status']}');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  // Method to get coordinates from address using Geocoding API
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json'
          '?address=${Uri.encodeComponent(address)}'
          '&key=${AppConstant.apiKey}';

      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        print('Geocoding API Error: ${response.data['status']}');

        // Try with Bangladesh appended
        final urlWithCountry =
            'https://maps.googleapis.com/maps/api/geocode/json'
            '?address=${Uri.encodeComponent('$address, Bangladesh')}'
            '&key=${AppConstant.apiKey}';

        final responseWithCountry = await _dio.get(urlWithCountry);

        if (responseWithCountry.statusCode == 200 &&
            responseWithCountry.data['status'] == 'OK') {
          final location =
              responseWithCountry.data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }

        return null;
      }
    } catch (e) {
      print('Error geocoding address: $e');
      return null;
    }
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
}
