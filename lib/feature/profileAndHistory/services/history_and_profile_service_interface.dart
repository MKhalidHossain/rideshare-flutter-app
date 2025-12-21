import 'package:get/get_connect/http/src/response/response.dart';

abstract class HistoryAndProfileServiceInterface {
  Future<Response> getProfile();
  Future<Response> updateProfile(String fullName, String email);
  Future<Response> updateProfileImage(String image);
  Future<Response> updateLocation(
    String latitude,
    String longitude,
    String address,
  );
}
