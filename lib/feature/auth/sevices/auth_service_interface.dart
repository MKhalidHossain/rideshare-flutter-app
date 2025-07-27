abstract class AuthServiceInterface {

  Future<dynamic> register(
    String email,
    String password,
    String confirmPassword,
  );
  Future<dynamic> login(String email,  String password);
  Future<dynamic> accessAndRefreshToken(String refreshToken);
  Future<dynamic> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  );
  Future<dynamic> forgetPassword(String? email);
  Future<dynamic> verifyCode(String email, String otp);
  Future<dynamic> resendOtp(String email);
  Future<dynamic> sendOtp({required String phone});
  Future<dynamic> resetPassword(String email ,String newPassword, String repeatNewPassword);
  Future<dynamic> logout();

  bool isLoggedIn();
  Future<bool> clearUserCredentials();
  bool clearSharedAddress();
  String getUserToken();

  Future<dynamic> updateToken();
  Future<bool?> saveUserToken(String token, String refreshToken);
  Future<dynamic> updateAccessAndRefreshToken();

  bool isFirstTimeInstall();
  void setFirstTimeInstall();
  Future<dynamic> chooseRole(String role);
}
