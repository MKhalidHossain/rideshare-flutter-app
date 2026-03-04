import '../domain/request_model/change_password_request_model.dart';

abstract class AuthRepositoryInterface {
  Future<dynamic> register(
    String fullName,
    String email,
    String? phoneNumber,
    String password,
    String role,
  );
  Future<dynamic> login(String emailOrPhone, String password);
  Future<dynamic> verifyOtp(String email, String otp, String type);
  Future<dynamic> forgetPassword(String? emailOrPhone);
  Future<dynamic> resetPassword(String emailOrPhone, String newPassword);
  Future<dynamic> changePassword(ChangePasswordRequestModel requestModel);

  Future<dynamic> accessAndRefreshToken(String refreshToken);

  bool isLoggedIn();
  Future<dynamic> saveLogin(String token);
  Future<dynamic> logout();

  Future<bool> clearUserCredentials();
  bool clearSharedAddress();
  String getUserToken();
  String getUserId();

  Future<dynamic> updateToken();
  Future<bool?> saveUserToken(String accessToken, String refreshToken);
  Future<bool?> saveUserId(String userId);
  Future<dynamic> updateAccessAndRefreshToken();

  bool isFirstTimeInstall();
  void setFirstTimeInstall();
}
