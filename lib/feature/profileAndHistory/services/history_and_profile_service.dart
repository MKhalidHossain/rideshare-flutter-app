import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/request_model/update_profile_request_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/repositories/history_and_profile_repository_interface.dart';

import 'history_and_profile_service_interface.dart';

class HistoryAndProfileService implements HistoryAndProfileServiceInterface {
  final HistoryAndProfileRepositoryInterface
  historyAndProfileRepositoryInterface;

  HistoryAndProfileService(this.historyAndProfileRepositoryInterface);

  @override
  Future<Response> getProfile() async {
    return await historyAndProfileRepositoryInterface.getProfile();
  }

  @override
  Future<Response> updateLocation(
    String latitude,
    String longitude,
    String address,
  ) async {
    return await historyAndProfileRepositoryInterface.updateLocation(
      latitude,
      longitude,
      address,
    );
  }

  @override
  Future<Response> updateProfile(String fullName, String email) async {
    return await historyAndProfileRepositoryInterface.updateProfile(
      fullName,
      email,
    );
  }

  @override
  Future<Response> updateProfileImage(XFile image) async {
    return await historyAndProfileRepositoryInterface.updateProfileImage(image);
  }

  @override
  Future<Response> getNotifications({int page = 1, int limit = 20}) async {
    return await historyAndProfileRepositoryInterface.getNotifications(
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Response> updateUserProfile(
    UpdateProfileRequestModel requestModel,
  ) async {
    return await historyAndProfileRepositoryInterface.updateUserProfile(
      requestModel,
    );
  }

  @override
  Future<Response> deleteAccount(String emailOrPhone) async {
    return await historyAndProfileRepositoryInterface.deleteAccount(
      emailOrPhone,
    );
  }
}
