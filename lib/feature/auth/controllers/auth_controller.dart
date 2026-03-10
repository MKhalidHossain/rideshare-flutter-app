import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rideztohealth/feature/auth/domain/model/change_password_response_model.dart';
import 'package:rideztohealth/feature/auth/domain/model/request_password_reset_response_model.dart';
import 'package:rideztohealth/feature/auth/domain/model/reset_password_with_otp_response_model.dart';
import 'package:rideztohealth/feature/auth/domain/model/verify_otp_response_model.dart';
import 'package:rideztohealth/feature/auth/domain/request_model/change_password_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app.dart';
import '../../../helpers/custom_snackbar.dart';
import '../../../helpers/remote/data/api_checker.dart';
import '../../../helpers/remote/data/api_client.dart';
import '../../../helpers/remote/data/socket_client.dart';
import '../domain/model/login_user_response_model.dart';
import '../domain/model/registration_user_response_model.dart';
import '../presentation/screens/reset_password_screen.dart';
import '../presentation/screens/user_login_screen.dart';
import '../presentation/screens/user_signup_screen.dart';
import '../presentation/screens/verify_otp_screen.dart';
import '../sevices/auth_service_interface.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;

  AuthController({required this.authServiceInterface});

  bool changePasswordIsLoading = false;

  bool? isFirstTime;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;
  final String _mobileNumber = '';
  String get mobileNumber => _mobileNumber;
  XFile? _pickedProfileFile;
  XFile? get pickedProfileFile => _pickedProfileFile;
  XFile identityImage = XFile('');
  List<XFile> identityImages = [];
  List<MultipartBody> multipartList = [];
  String countryDialCode = '+880';
  String email = '';
  final socketClient = SocketClient();

  void setCountryCode(String code) {
    countryDialCode = code;
    update();
  }

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();

  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode identityNumberNode = FocusNode();

  RegistrationResponseModel? registrationResponseModel;
  LogInResponseModel? logInResponseModel;
  static const int _maxLoginAttempts = 3;
  int _loginFailCount = 0;
  ChangePasswordResponseModel? changePasswordResponseModel;
  RequestPasswordResetResponseModel? requestPasswordResetResponseModel;
  ResetPasswordWithOtpResponseModel? resetPasswordWithOtpResponseModel;
  VerifyOtpResponseModel? verifyOtpResponseModel;
  // VerifyCodeResponseModel? verifyCodeResponseModel;
  // ChangePasswordResponseModel? changePasswordResponseModel;
  // ForgetPasswordResponseModel? forgetPasswordResponseModel;

  void addImageAndRemoveMultiParseData() {
    multipartList.clear();
    identityImages.clear();
    update();
  }

  void pickImage(bool isBack, bool isProfile) async {
    if (isProfile) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _pickedProfileFile = pickedFile;
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        identityImage = pickedFile;
        identityImages.add(identityImage);
        multipartList.add(MultipartBody('identity_images[]', identityImage));
      }
    }
    update();
  }

  void removeImage(int index) {
    identityImages.removeAt(index);
    multipartList.removeAt(index);
    update();
  }

  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  List<String> get identityTypeList => _identityTypeList;
  String _identityType = '';
  String get identityType => _identityType;

  void setIdentityType(String setValue) {
    _identityType = setValue;
    update();
  }

  Future<void> register(
    String otpVerifyType,
    String fullName,
    String email,
    String? phoneNumber,
    String password,
    String role,
  ) async {
    if (_isLoading) {
      return;
    }

    final String normalizedFullName = fullName.trim();
    final String normalizedEmail = email.trim().toLowerCase();
    final String normalizedPassword = password.trim();
    final String normalizedRole = role.trim();
    final String? normalizedPhoneNumber = phoneNumber?.trim();

    _isLoading = true;
    update();

    print(
      "REGISTER API BODY: {fullName: $normalizedFullName, email: $normalizedEmail, password: $normalizedPassword, role: $normalizedRole}",
    );

    try {
      Response? response = await authServiceInterface.register(
        normalizedFullName,
        normalizedEmail,
        normalizedPhoneNumber,
        normalizedPassword,
        normalizedRole,
      );
      if (response!.statusCode == 201) {
        registrationResponseModel = RegistrationResponseModel.fromJson(
          response.body,
        );

        print('\nemail: $normalizedEmail , otpVerifyType: $otpVerifyType\n');
        Get.off(
          () => VerifyOtpScreen(
            email: normalizedEmail,
            otpVerifyType: otpVerifyType,
          ),
        );

        showCustomSnackBar(
          response.body['message'] ??
              'Registration success Now need to email verification',
        );
        showCustomSnackBar('Please check your email to verify your account');
        // Get.off(() => UserLoginScreen());
        // showCustomSnackBar('Welcome you have successfully Registered');
      } else {
        final String apiMessage = _extractResponseMessage(response.body);
        final bool isDuplicateEntry = apiMessage.toLowerCase().contains(
          'duplicate',
        );

        if (response.statusCode == 400) {
          showCustomSnackBar(
            isDuplicateEntry
                ? 'An account with this email or phone already exists. Please sign in or use different information.'
                : (apiMessage.isNotEmpty ? apiMessage : 'Something went wrong'),
            isError: true,
          );
        } else {
          showCustomSnackBar(
            apiMessage.isNotEmpty
                ? apiMessage
                : 'Registration failed. Please try again.',
            isError: true,
          );
        }

        print(
          ' ❌ Registration failed: ${response.statusCode} ${response.body} ',
        );
      }
    } catch (e) {
      print("❌ Error during registration: $e");
      showCustomSnackBar(
        "Something went wrong. Please try again later.",
        isError: true,
      );
    } finally {
      _isLoading = false;
      update();
    }
  }

  String _extractResponseMessage(dynamic body) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }
    return '';
  }

  Future<void> login(String emailOrPhone, String password) async {
    _isLoading = true;
    update();

    // Response? response = Response();

    Response? response = await authServiceInterface.login(
      emailOrPhone,
      password,
    );

    if (response == null) {
      print("No response found");
      _loginFailCount++;
      if (_loginFailCount >= _maxLoginAttempts) {
        _loginFailCount = 0;
        _isLoading = false;
        update();
        Get.offAll(UserSignupScreen());
        showCustomSnackBar(
          'Too many failed attempts. Please create an account.',
        );
        return;
      }
      _isLoading = false;
      update();
      return;
    }
    if (response.statusCode == 200) {
      String accessToken = '';
      String refreshToken = '';
      String userId = '';

      print(accessToken.toString());

      logInResponseModel = LogInResponseModel.fromJson(response.body);

      refreshToken = logInResponseModel!.data!.refreshToken!;
      accessToken = logInResponseModel!.data!.accessToken!;
      userId = logInResponseModel!.data!.user!.id!.trim();
      print(
        'accessToken ${logInResponseModel!.data!.accessToken}} NOW Iwalker',
      );
      print('refreshToken $refreshToken NOW Iwalker');
      print(
        'User Token $accessToken  ================================== from comtroller ',
      );
      await setUserId(userId);
      await setUserToken(accessToken, refreshToken).then((_) async {
        // await Future.delayed(Duration(seconds: 3),
        // );
        socketClient.emit('join-user', {
          'userId': userId, // ei key ta backend expect korche
        });
        print('socket join with sender id To chekkkkkkkikk: ${userId}');
        Get.offAll(() => AppMain());
      });

      //Get.offAll(BottomNavbar());

      showCustomSnackBar('Welcome you have successfully Logged In');

      _loginFailCount = 0;
      _isLoading = false;
    } else {
      _loginFailCount++;
      if (_loginFailCount >= _maxLoginAttempts) {
        _loginFailCount = 0;
        _isLoading = false;
        update();
        Get.offAll(UserSignupScreen());
        showCustomSnackBar(
          'Too many failed attempts. Please create an account.',
        );
        return;
      }
      if (response.statusCode == 202) {
        if (response.body['data']['is_phone_verified'] == 0) {}
      } else if (response.statusCode == 400) {
        showCustomSnackBar(
          'Sorry you have no account, please create a account',
        );
      } else if (response.statusCode == 401) {
        showCustomSnackBar(
          'Login Failed',
          subMessage:
              'The email or password you entered is incorrect. Please try again.',
        );
      } else {
        ApiChecker.checkApi(response);
      }
    }

    _isLoading = false;
    update();
  }

  Future<void> logOut() async {
    logging = true;
    update();
    Response? response = await authServiceInterface.logout();

    if (isLoggedIn() == false) {
      if (response!.statusCode == 200) {
        Get.offAll(() => UserLoginScreen());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomSnackBar('You have logout Successfully');
        });
      } else {
        logging = false;
        ApiChecker.checkApi(response);
        print(response.body['message'] + ' for logout from controller');
        showAppSnackBar(
          'Error',
          response.body['message']?.toString() ?? 'Unknown error',
          isError: true,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        Get.offAll(() => UserLoginScreen());
      }
    } else {
      print(response.toString() + ' from controller');
    }
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> isFirstTimeInstall() async {
    _isLoading = true;
    update();
    final prefs = await SharedPreferences.getInstance();

    isFirstTime = prefs.getBool('firstTimeInstall') ?? true;

    if (isFirstTime!) {
      await prefs.setBool('firstTimeInstall', false);
      _isLoading = false;
      update();
      return true; // means first time
    } else {
      _isLoading = false;
      update();
      return false; // not first time
    }
  }

  bool logging = false;

  // Future<void> logOut() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   logging = true;
  //   update();
  //   Response? response = await authServiceInterface.logout();

  //   if (isLoggedIn() == true) {
  //     if (response!.statusCode == 200) {
  //       await preferences.setString(AppConstants.token, '');
  //       await preferences.setString(AppConstants.refreshToken, '');

  //       showCustomSnackBar('You have logout Successfully');
  //     } else {
  //       logging = false;
  //       ApiChecker.checkApi(response);
  //     }
  //   } else {
  //     print('object fucked up');
  //   }
  //   update();
  // }

  Future<void> permanentDelete() async {
    logging = true;

    update();
  }

  Future<void> verifyOtp(String email, String otp, String type) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.verifyOtp(email, otp, type);

    print(response!.body);

    if (response.body['success'] == true) {
      verifyOtpResponseModel = VerifyOtpResponseModel.fromJson(response.body);
      showCustomSnackBar('Otp verification has been successful');

      if (type == 'password_reset') {
        Get.to(ResetChangePassword(userEmail: email));
      } else if (type == 'email_verification') {
        showCustomSnackBar('Email verification has been successful');
        Get.offAll(() => UserLoginScreen());
      } else if (type == 'password_reset') {
        showCustomSnackBar('Password Change Successfully');
        Get.offAll(() => UserSignupScreen());
      } else {
        showCustomSnackBar('Otp type is not valid');
        Get.offAll(() => UserSignupScreen());
      }

      // Get.to(ResetChangePassword(userEmail: email));
    } else {
      showCustomSnackBar(
        'Otp is not valid, Please try again',
        subMessage: response.body['message'],
        isError: true,
      );
      // Get.find<AuthController>().logOut();
    }
    _isLoading = false;
    update();
  }

  // Future<void> resendOtp(String email) async {
  //   _isLoading = true;
  //   update();
  //   Response? response = await authServiceInterface.resendOtp(email);
  //   if (response!.body['status'] == true) {
  //     showCustomSnackBar('Otp has been successful to your mail');

  //     Get.to(VerifyOtpScreen(email: email));
  //   }

  //   update();
  // }

  Future<void> forgetPassword(String emailOrPhone, String otpVerifyType) async {
    _isLoading = true;
    update();

    Response? response = await authServiceInterface.forgetPassword(
      emailOrPhone,
    );
    print(response!.body);

    if (response.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBar('successfully sent otp');
      print('\neamil $emailOrPhone , otpVerifyType $otpVerifyType\n');
      Get.to(
        () =>
            VerifyOtpScreen(email: emailOrPhone, otpVerifyType: otpVerifyType),
      );
    } else {
      _isLoading = false;
      showCustomSnackBar('invalid mail');
    }
    update();
  }

  // Future<void> resetPassword(String email, String newPassword) async {
  //   _isLoading = true;

  //   update();

  //   Response? response = await authServiceInterface.resetPassword(
  //     email,
  //     newPassword,
  //   );
  //   if (response!.statusCode == 200) {
  //     // SnackBarWidget('password_change_successfully'.tr, isError: false);
  //     showCustomSnackBar('Password Change Successfully');
  //     Get.offAll(() => const SignInScreen());
  //   } else {
  //     showCustomSnackBar('Password Change was  Unsuccessfully');
  //     ApiChecker.checkApi(response);
  //   }

  //   _isLoading = false;

  //   update();
  // }

  Future<void> resetPassword(String email, String newPassword) async {
    _isLoading = true;
    update();

    Response? response = await authServiceInterface.resetPassword(
      email,
      newPassword,
    );
    if (response!.statusCode == 200) {
      showCustomSnackBar('Password Change Successfully');
      // logOut();
      // Get.to(UserLoginScreen());
      Get.offAll(() => UserLoginScreen());
    } else {
      showCustomSnackBar(response.body['message'] ?? 'Something went wrong');
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> changePassword(ChangePasswordRequestModel requestModel) async {
    changePasswordIsLoading = true;
    update();

    try {
      Response? response = await authServiceInterface.changePassword(
        requestModel,
      );

      if (response == null) {
        showCustomSnackBar(
          'Unable to reach the server. Please try again.',
          isError: true,
        );
      } else {
        changePasswordResponseModel = ChangePasswordResponseModel.fromJson(
          response.body,
        );

        if (response.statusCode == 200 &&
            (changePasswordResponseModel?.success ?? false)) {
          showCustomSnackBar(
            changePasswordResponseModel?.message ??
                'Password changed successfully',
          );
          Get.back();
        } else {
          showCustomSnackBar(
            changePasswordResponseModel?.message ??
                response.body['message'] ??
                'Unable to change password',
            isError: true,
          );
          ApiChecker.checkApi(response);
        }
      }
    } catch (e) {
      print("❌ Error changing password: $e");
      showCustomSnackBar(
        "Something went wrong. Please try again later.",
        isError: true,
      );
    }

    changePasswordIsLoading = false;
    update();
  }

  bool updateFcm = false;

  Future<void> updateAccessAndRefreshToken() async {
    Response? response = await authServiceInterface
        .updateAccessAndRefreshToken();
    if (response?.statusCode == 200) {
      String token = response!.body['accessToken'];
      String refreshToken = response.body['refreshToken'];

      print('accessToken $token NOWW');
      print('refreshToken $refreshToken');

      setUserToken(token, refreshToken);
      updateFcm = false;
    } else {
      updateFcm = false;
      ApiChecker.checkApi(response!);
    }

    update();
  }

  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if (_verificationCode.isNotEmpty) {
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode() {
    updateVerificationCode('');
    _verificationCode = '';
    update();
  }

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  String getUserId() {
    return authServiceInterface.getUserId();
  }

  Future<void> setUserToken(String accessToken, String refreshToken) async {
    await authServiceInterface.saveUserToken(accessToken, refreshToken);
  }

  Future<void> setUserId(String userId) async {
    await authServiceInterface.saveUserId(userId);
  }

  Future<bool> getFirsTimeInstall() async {
    return await authServiceInterface.isFirstTimeInstall();
  }

  void setFirstTimeInstall() {
    return authServiceInterface.setFirstTimeInstall();
  }
}
