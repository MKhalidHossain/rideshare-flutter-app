import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/request_model/update_profile_request_model.dart';

abstract class HistoryAndProfileServiceInterface {
  Future<Response> getProfile();
  Future<Response> updateProfile(String fullName, String email);
  Future<Response> updateProfileImage(XFile image);
  Future<Response> getNotifications({int page = 1, int limit = 20});
  Future<Response> updateLocation(
    String latitude,
    String longitude,
    String address,
  );
  Future<Response> updateUserProfile(UpdateProfileRequestModel requestModel);
  Future<Response> deleteAccount(String emailOrPhone);
}
