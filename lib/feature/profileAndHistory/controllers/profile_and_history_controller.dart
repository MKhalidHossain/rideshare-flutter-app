import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/get_profile_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/update_location_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/update_profile_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/upload_profile_image_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/services/history_and_profile_service_interface.dart';

class ProfileAndHistoryController extends GetxController implements GetxService {
  final HistoryAndProfileServiceInterface historyAndProfileServiceInterface;

  ProfileAndHistoryController(this.historyAndProfileServiceInterface);

  GetProfileResponseModel getProfileResponseModel = GetProfileResponseModel();
  UpdateProfileResponseModel updateProfileResponseModel =
      UpdateProfileResponseModel();
  UploadProfileImageResponseModel uploadProfileImageResponseModel =
      UploadProfileImageResponseModel();
  UpdateLocationResponseModel updateLocationResponseModel =
      UpdateLocationResponseModel();

  bool isLoading = false;

  Future<void> getProfile() async {
    try {
      isLoading = true;
      update();

      final response = await historyAndProfileServiceInterface.getProfile();

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ getProfile : for User Profile fetched successfully \n");
        getProfileResponseModel = GetProfileResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
        getProfileResponseModel = GetProfileResponseModel.fromJson(
          response.body,
        );
      }
    } catch (e) {
      print("⚠️ Error fetching profile : getProfile : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateProfile(String fullName, String email) async {
    try {
      isLoading = true;
      update();

      final response = await historyAndProfileServiceInterface.updateProfile(
        fullName,
        email,
      );

      debugPrint("Status Code : ${response.statusCode}");
      debugPrint("Response Body : ${response.body}");

      if (response.statusCode == 200) {
        print("✅ updateProfile : for User Profile updated successfully \n");
        updateProfileResponseModel = UpdateProfileResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
        updateProfileResponseModel = UpdateProfileResponseModel.fromJson(
          response.body,
        );
      }
    } catch (e) {
      print("⚠️ Error updating profile : updateProfile : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateProfileImage(String image) async {
    try {
      isLoading = true;
      update();

      final response = await historyAndProfileServiceInterface
          .updateProfileImage(image);

      debugPrint("Status Code : ${response.statusCode}");
      debugPrint("Response Body : ${response.body}");

      if (response.statusCode == 200) {
        print(
          "✅ updateProfileImage : for User Profile updated successfully \n",
        );
        uploadProfileImageResponseModel =
            UploadProfileImageResponseModel.fromJson(response.body);

        isLoading = false;
        update();
      } else {
        uploadProfileImageResponseModel =
            UploadProfileImageResponseModel.fromJson(response.body);
      }
    } catch (e) {
      print("⚠️ Error updating profile : updateProfileImage : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateLocation(
    String latitude,
    String longitude,
    String address,
  ) async {
    try {
      isLoading = true;
      update();

      final response = await historyAndProfileServiceInterface.updateLocation(
        latitude,
        longitude,
        address,
      );

      debugPrint("Status Code : ${response.statusCode}");
      debugPrint("Response Body : ${response.body}");

      if (response.statusCode == 200) {
        print("✅ updateLocation : for User Profile updated successfully \n");
        updateLocationResponseModel = UpdateLocationResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
        updateLocationResponseModel = UpdateLocationResponseModel.fromJson(
          response.body,
        );
      }
    } catch (e) {
      print("⚠️ Error updating profile : updateLocation : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }
}
