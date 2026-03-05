import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/helpers/remote/data/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/urls.dart';
import '../domain/request_model/update_profile_request_model.dart';
import 'history_and_profile_repository_interface.dart';

class HistoryAndProfileRepository
    implements HistoryAndProfileRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  HistoryAndProfileRepository(this.apiClient, this.sharedPreferences);
  @override
  Future<Response> getProfile() async {
    return await apiClient.getData(Urls.getProfile);
  }

  @override
  Future<Response> updateLocation(
    String latitude,
    String longitude,
    String address,
  ) async {
    return await apiClient.putData(Urls.updateLocation, {
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
    });
  }

  @override
  Future<Response> updateProfile(String fullName, String email) async {
    return await apiClient.putData(Urls.updateProfile, {
      "fullName": fullName,
      "email": email,
    });
  }

  @override
  Future<Response> updateProfileImage(XFile image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(Urls.baseUrl + Urls.uploadProfileImage),
    );

    final headers = apiClient.getHeader();
    headers.remove('Content-Type'); // Multipart sets its own boundary
    request.headers.addAll(headers);

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: image.name,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return apiClient.handleResponse(response, Urls.uploadProfileImage);
  }

  @override
  Future<Response> getNotifications({int page = 1, int limit = 20}) async {
    final query = '?page=$page&limit=$limit';
    return await apiClient.getData(Urls.getNotifications + query);
  }

  @override
  Future<Response> updateUserProfile(
    UpdateProfileRequestModel requestModel,
  ) async {
    return await apiClient.putData(
      Urls.updateProfile,
      requestModel.toJson(),
    );
  }

  @override
  Future<Response> deleteAccount(String emailOrPhone) async {
    final request = http.Request(
      'DELETE',
      Uri.parse(Urls.baseUrl + Urls.deleteAccount),
    );
    request.headers.addAll(apiClient.getHeader());
    request.body = jsonEncode({'emailOrPhone': emailOrPhone});

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return apiClient.handleResponse(response, Urls.deleteAccount);
  }
}
