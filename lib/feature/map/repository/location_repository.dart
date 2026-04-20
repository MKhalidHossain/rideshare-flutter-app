import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rideztohealth/core/constants/app_constant.dart';
import 'package:rideztohealth/feature/map/domain/models/place_prediction.dart';
import 'package:rideztohealth/helpers/remote/data/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_repository_interface.dart';

class LocationRepository implements LocationRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationRepository(this.apiClient, this.sharedPreferences);

  @override
  Future<List<PlacePrediction>> searchPlaces({required String query}) async {
    if (query.trim().isEmpty) return [];

    // Use Uri.https so query is properly encoded
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': AppConstant.apiKey,
        'language': 'en',
        // 🔹 Only Bangladesh + USA suggestions
        'components': 'country:bd|country:us',
        // Optional: prefer addresses
        // 'types': 'geocode',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      debugPrint('Places API HTTP Error: ${response.statusCode}');
      return [];
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['status'] != 'OK') {
      debugPrint(
        'Places API Error: ${data['status']} - ${data['error_message'] ?? ''}',
      );
      return [];
    }

    final List predictions = data['predictions'] ?? [];

    return predictions
        .map<PlacePrediction>(
          (e) => PlacePrediction.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }


}
