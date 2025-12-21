import 'package:get/get_connect/http/src/response/response.dart';
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
  Future<Response> updateProfileImage(String image) async {
    return await historyAndProfileRepositoryInterface.updateProfileImage(image);
  }
}
