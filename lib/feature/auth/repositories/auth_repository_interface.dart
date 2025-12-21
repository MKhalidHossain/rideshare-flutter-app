abstract class AuthRepositoryInterface {
  Future<dynamic> register(
    String fullName,
    String email,
    String phoneNumber,
    String password,
    String role,
  );
  Future<dynamic> login(String emailOrPhone, String password);
  Future<dynamic> verifyOtp(String email, String otp, String type);
  Future<dynamic> forgetPassword(String? emailOrPhone);
  Future<dynamic> resetPassword(String emailOrPhone, String newPassword);
  Future<dynamic> changePassword(String currentPassword, String newPassword);

  Future<dynamic> accessAndRefreshToken(String refreshToken);

  bool isLoggedIn();
  Future<dynamic> saveLogin(String token);
  Future<dynamic> logout();

  Future<bool> clearUserCredentials();
  bool clearSharedAddress();
  String getUserToken();

  Future<dynamic> updateToken();
  Future<bool?> saveUserToken(String accessToken, String refreshToken);
  Future<dynamic> updateAccessAndRefreshToken();

  bool isFirstTimeInstall();
  void setFirstTimeInstall();
}
