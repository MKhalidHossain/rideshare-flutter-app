import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/urls.dart';
import '../../../helpers/remote/data/api_client.dart';
import '../../../utils/app_constants.dart';
import '../domain/request_model/change_password_request_model.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;

  final SharedPreferences sharedPreferences;
  AuthRepository({required this.apiClient, required this.sharedPreferences});

  RxString _token = "".obs;

  @override
  Future accessAndRefreshToken(Pattern refreshToken) async {
    return await apiClient.postData(Urls.refreshAccessToken, {});
  }

  @override
  Future changePassword(ChangePasswordRequestModel requestModel) async {
    return await apiClient.postData(Urls.changePassword, requestModel.toJson());
  }

  @override
  bool clearSharedAddress() {
    throw UnimplementedError();
  }

  @override
  Future<bool> clearUserCredentials() async {
    // sharedPreferences.remove(AppConstants.token);
    return await sharedPreferences.clear();
  }

  @override
  String getUserToken() {
    final token = sharedPreferences.getString(AppConstants.accessToken) ?? '';
    apiClient.updateHeader(token);
    return token;
  }

  @override
  String getUserId() {
    final userId = sharedPreferences.getString(AppConstants.userId) ?? '';
    return userId;
  }

  // @override
  // bool isFirstTimeInstall() {
  //   return sharedPreferences.containsKey(AppConstants.token);
  // }

  @override
  bool isFirstTimeInstall() {
    if (sharedPreferences.getBool('firstTimeInstall') == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isLoggedIn() {
    try {
      final token = sharedPreferences.getString(AppConstants.accessToken);
      apiClient.updateHeader(token ?? '');
      return token != null && token.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<void> saveLogin(String token) async {
    await sharedPreferences.setString('IsLoggedIn', token);
    _token.value = token;
  }

  @override
  Future login(String emailOrPhone, String password) async {
    return await apiClient.postData(Urls.login, {
      'emailOrPhone': emailOrPhone,
      'password': password,
    });
  }

  @override
  Future logout() async {
    return await apiClient.postData(Urls.logOut, {}).then((response) {
      clearUserCredentials();
      return response;
    });
  }

  @override
  Future register(
    String fullName,
    String email,
    String? phoneNumber,
    String password,
    String role,
  ) async {
    final requestBody = {
      'fullName': fullName,
      'email': email,
      'password': password,
      'role': role,
    };

    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      requestBody['phoneNumber'] = phoneNumber.trim();
    }

    return await apiClient.postData(Urls.register, requestBody);
  }

  @override
  Future forgetPassword(String? emailOrPhone) async {
    return await apiClient.postData(Urls.forgetPassword, {
      'emailOrPhone': emailOrPhone,
    });
  }

  // @override
  // Future resetPassword(
  //   String email,
  //   String newPassword,
  //   String repeatNewPassword,
  // ) {
  //   // TODO: implement resetPassword
  //   throw UnimplementedError();
  // }

  @override
  Future resetPassword(String emailOrPhone, String newPassword) async {
    return await apiClient.postData(Urls.resetPasswordWithOtp, {
      'emailOrPhone': emailOrPhone,
      'newPassword': newPassword,
    });
  }

  @override
  Future<bool?> saveUserToken(String accessToken, String refreshToken) async {
    final accessSaved = await sharedPreferences.setString(
      AppConstants.accessToken,
      accessToken,
    );
    final refreshSaved = await sharedPreferences.setString(
      AppConstants.refreshToken,
      refreshToken,
    );
    apiClient.updateHeader(accessToken);
    return accessSaved && refreshSaved;
  }

  @override
  Future<bool?> saveUserId(String userId) async {
    return await sharedPreferences.setString(AppConstants.userId, userId);
  }

  @override
  void setFirstTimeInstall() {
    sharedPreferences.setBool('firstTimeInstall', true);
  }

  @override
  Future updateAccessAndRefreshToken() async {
    return await apiClient.postData(Urls.refreshAccessToken, {
      'refreshToken': sharedPreferences.getString(AppConstants.refreshToken),
    });
  }

  @override
  Future updateToken() {
    // TODO: implement updateToken
    throw UnimplementedError();
  }

  @override
  Future verifyOtp(String email, String otp, String type) async {
    return await apiClient.postData(Urls.verifyOtp, {
      'email': email,
      'otp': otp,
      'type': type,
    });
  }
}
