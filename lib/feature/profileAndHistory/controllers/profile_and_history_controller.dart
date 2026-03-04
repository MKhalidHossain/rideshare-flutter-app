import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/get_profile_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/update_location_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/update_profile_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/upload_profile_image_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/model/notification_response_model.dart';
import 'package:rideztohealth/feature/profileAndHistory/domain/request_model/update_profile_request_model.dart';
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
  NotificationResponseModel notificationResponseModel =
      NotificationResponseModel();
  List<AppNotification> notifications = [];

  bool isLoading = false;
  bool notificationsLoading = false;
  bool deleteAccountLoading = false;

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

  Future<void> fetchNotifications({int page = 1, int limit = 20}) async {
    try {
      notificationsLoading = true;
      update();

      final response = await historyAndProfileServiceInterface.getNotifications(
        page: page,
        limit: limit,
      );

      debugPrint("Notifications Status : ${response.statusCode}");
      debugPrint("Notifications Body : ${response.body}");

      if (response.statusCode == 200) {
        notificationResponseModel =
            NotificationResponseModel.fromJson(response.body);
        notifications = notificationResponseModel.data?.notifications ?? [];
      } else {
        notificationResponseModel =
            NotificationResponseModel.fromJson(response.body);
        notifications = notificationResponseModel.data?.notifications ?? [];
      }
    } catch (e) {
      print("⚠️ Error fetching notifications : $e\n");
    } finally {
      notificationsLoading = false;
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

  Future<void> updateProfileImage(XFile image) async {
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

  Future<void> updateUserProfile(
    UpdateProfileRequestModel requestModel,
  ) async {
    try {
      isLoading = true;
      update();

      final response = await historyAndProfileServiceInterface
          .updateUserProfile(requestModel);

      debugPrint("Status Code : ${response.statusCode}");
      debugPrint("Response Body : ${response.body}");

      if (response.statusCode == 200) {
        updateProfileResponseModel = UpdateProfileResponseModel.fromJson(
          response.body,
        );
      } else {
        updateProfileResponseModel = UpdateProfileResponseModel.fromJson(
          response.body,
        );
      }
    } catch (e) {
      print("⚠️ Error updating profile : updateUserProfile : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<Response?> deleteAccount(String emailOrPhone) async {
    try {
      deleteAccountLoading = true;
      update();

      final response =
          await historyAndProfileServiceInterface.deleteAccount(emailOrPhone);

      debugPrint("Delete Account Status : ${response.statusCode}");
      debugPrint("Delete Account Body : ${response.body}");

      return response;
    } catch (e) {
      print("⚠️ Error deleting account : $e\n");
      return null;
    } finally {
      deleteAccountLoading = false;
      update();
    }
  }
}
