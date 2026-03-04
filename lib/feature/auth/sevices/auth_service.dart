import '../domain/request_model/change_password_request_model.dart';
import '../repositories/auth_repository_interface.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;

  AuthService(this.authRepositoryInterface);

  @override
  Future accessAndRefreshToken(String refreshToken) async {
    return await authRepositoryInterface.accessAndRefreshToken(refreshToken);
  }

  @override
  Future changePassword(ChangePasswordRequestModel requestModel) async {
    return await authRepositoryInterface.changePassword(requestModel);
  }

  @override
  bool clearSharedAddress() {
    return authRepositoryInterface.clearSharedAddress();
  }

  @override
  Future<bool> clearUserCredentials() async {
    return await authRepositoryInterface.clearUserCredentials();
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  String getUserId() {
    return authRepositoryInterface.getUserId();
  }

  @override
  bool isFirstTimeInstall() {
    return authRepositoryInterface.isFirstTimeInstall();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  Future saveLogin(String token) {
    return authRepositoryInterface.saveLogin(token);
  }

  @override
  Future login(String emailOrPhone, String password) async {
    return await authRepositoryInterface.login(emailOrPhone, password);
  }

  @override
  Future logout() async {
    return await authRepositoryInterface.logout();
  }

  @override
  Future register(
    String fullName,
    String email,
    String? phoneNumber,
    String password,
    String role,
  ) async {
    return await authRepositoryInterface.register(
      fullName,
      email,
      phoneNumber,
      password,
      role,
    );
  }

  @override
  Future forgetPassword(String? emailOrPhone) async {
    return await authRepositoryInterface.forgetPassword(emailOrPhone);
  }

  @override
  Future resetPassword(String emailOrPhone, String newPassword) async {
    return await authRepositoryInterface.resetPassword(
      emailOrPhone,
      newPassword,
    );
  }

  @override
  Future<bool?> saveUserToken(String accessToken, String refreshToken) async {
    return await authRepositoryInterface.saveUserToken(
      accessToken,
      refreshToken,
    );
  }

  @override
  Future<bool?> saveUserId(String userId) async {
    return await authRepositoryInterface.saveUserId(userId);
  }

  @override
  void setFirstTimeInstall() {
    authRepositoryInterface.setFirstTimeInstall();
  }

  @override
  Future updateAccessAndRefreshToken() async {
    return await authRepositoryInterface.updateAccessAndRefreshToken();
  }

  @override
  Future updateToken() async {
    return await authRepositoryInterface.updateToken();
  }

  @override
  Future verifyOtp(String email, String otp, String type) async {
    return await authRepositoryInterface.verifyOtp(email, otp, type);
  }
}
