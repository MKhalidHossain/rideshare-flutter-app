import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/urls.dart';
import '../../../helpers/remote/data/api_client.dart';
import '../../../utils/app_constants.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;

  final SharedPreferences sharedPreferences;
  AuthRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future register(String email, String password, String confirmPassword) async {
    return await apiClient.postData(Urls.register, {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    });
  }

  @override
  Future accessAndRefreshToken(String refreshToken) async {
    return await apiClient.postData(Urls.refreshAccessToken, {
      "refreshToken": refreshToken,
    });
  }

  @override
  Future login(String email, String password) async {
    return await apiClient.postData(Urls.login, {
      "email": email,
      "password": password,
    });
  }

  @override
  Future forgetPassword(String? email) async {
    return await apiClient.postData(Urls.forgetPassword, {"email": email});
  }

  @override
  Future verifyCode(String otp, String email) async {
    return await apiClient.postData(Urls.verifyCode, {
      "email": email,
      "otp": int.tryParse(otp),
    });
  }

  @override
  Future resetPassword(
    String email,
    String newPassword,
    String repeatNewPassword,
  ) async {
    return await apiClient.postData(Urls.resetPassword, {
      "email": email,
      "newPassword": newPassword,
      "repeatNewPassword": repeatNewPassword,
    });
  }

  @override
  bool isLoggedIn() {
    sharedPreferences.getString(AppConstants.token);
    bool isLoggedIn = sharedPreferences.getBool('IsLoggedIn') ?? false;
    if (isLoggedIn) {
      return true;
    }
    return false;
  }

  @override
  Future logout() {
    sharedPreferences.setBool('IsLoggedIn', false);
    return apiClient.postData(AppConstants.logout, {});
  }

  @override
  Future<bool?> saveUserToken(String token, String refreshToken) async {
    print(
      'User Token ${token.toString()} ================================== from Repository ',
    );
    apiClient.token = token;
    apiClient.updateHeader(token);
    await sharedPreferences.setString(AppConstants.refreshToken, token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  @override
  bool isFirstTimeInstall() {
    if (sharedPreferences.getBool('firstTimeInstall') == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void setFirstTimeInstall() {
    sharedPreferences.setBool('firstTimeInstall', true);
  }

  @override
  bool clearSharedAddress() {
    throw UnimplementedError();
  }

  @override
  Future<bool> clearUserCredentials() {
    throw UnimplementedError();
  }

  @override
  String getUserToken() {
    throw UnimplementedError();
  }

  @override
  Future resendOtp(String email) {
    return apiClient.postData(Urls.forgetPassword, {"email": email});
  }

  @override
  Future sendOtp({required String phone}) {
    throw UnimplementedError();
  }

  @override
  Future updateToken() {
    throw UnimplementedError();
  }

  @override
  Future changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    return await apiClient.putData(Urls.changePassword, {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "confirmNewPassword": confirmPassword,
    });
  }

  @override
  Future updateAccessAndRefreshToken() {
    throw UnimplementedError();
  }

  @override
  Future chooseRole(String role) async {
    return await apiClient.postData(Urls.chooseRole, {"role": role});
  }
}
