import 'package:get/get_connect/http/src/response/response.dart';
import 'package:rideztohealth/helpers/remote/data/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/urls.dart';
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
  Future<Response> updateProfileImage(String image) async {
    return await apiClient.postData(Urls.uploadProfileImage, {"image": image});
  }
}
