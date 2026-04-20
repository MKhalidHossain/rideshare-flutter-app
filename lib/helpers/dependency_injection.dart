import 'package:get/get.dart';
import 'package:rideztohealth/feature/map/controllers/locaion_controller.dart';
import 'package:rideztohealth/feature/map/repository/location_repository.dart';
import 'package:rideztohealth/feature/map/service/location_service.dart';
import 'package:rideztohealth/feature/map/service/location_service_interface.dart';
import 'package:rideztohealth/feature/profileAndHistory/repositories/history_and_profile_repository.dart';
import 'package:rideztohealth/feature/profileAndHistory/repositories/history_and_profile_repository_interface.dart';
import 'package:rideztohealth/feature/profileAndHistory/services/history_and_profile_service.dart';
import 'package:rideztohealth/feature/profileAndHistory/services/history_and_profile_service_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'remote/data/api_client.dart';
import 'remote/data/socket_client.dart';

import '../core/constants/urls.dart';
import '../feature/auth/controllers/auth_controller.dart';
import '../feature/auth/repositories/auth_repository.dart';
import '../feature/auth/repositories/auth_repository_interface.dart';
import '../feature/auth/sevices/auth_service.dart';
import '../feature/auth/sevices/auth_service_interface.dart';
import '../feature/home/controllers/home_controller.dart';
import '../feature/home/repositories/home_repository.dart';
import '../feature/home/repositories/home_repository_interface.dart';
import '../feature/home/services/home_service.dart';
import '../feature/home/services/home_service_interface.dart';
import '../feature/map/repository/location_repository_interface.dart';
import '../feature/profileAndHistory/controllers/profile_and_history_controller.dart';


Future<void> initDI() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    final socket = SocketClient();

    socket.connect(
    url: Urls.socketUrl,
     autoConnect: true
     );
     

  ApiClient apiClient = ApiClient(
    appBaseUrl: Urls.baseUrl,
    sharedPreferences: prefs,
  );

  //////////// Auth Service, Repository and Controller ////////////////////////////////

  Get.lazyPut(() => apiClient);
  // Get.lazyPut(
  //   () => AuthRepository(apiClient: Get.find(), sharedPreferences: prefs),
  // );
  AuthRepositoryInterface authRepositoryInterface = AuthRepository(
    apiClient: Get.find(),
    sharedPreferences: prefs,
  );
  Get.lazyPut<AuthRepositoryInterface>(() => authRepositoryInterface);
  AuthServiceInterface authServiceInterface = AuthService(Get.find());
  Get.lazyPut(() => authServiceInterface);
  Get.lazyPut(() => AuthController(authServiceInterface: Get.find()));
  Get.lazyPut(() => AuthService(Get.find()));

  //////////// Profile Service, Repository and Controller ////////////////////////////////
  ///
  ///

  HistoryAndProfileRepositoryInterface profileRepositoryInterface =
      HistoryAndProfileRepository(Get.find(), prefs);
  Get.lazyPut(() => profileRepositoryInterface);
  HistoryAndProfileServiceInterface profileServiceInterface =
      HistoryAndProfileService(Get.find());
  Get.lazyPut(() => profileServiceInterface);
  Get.lazyPut(() => ProfileAndHistoryController(profileServiceInterface));
  Get.lazyPut(() => HistoryAndProfileService(Get.find()));

  //////////// home  Service, Repository and Controller ////////////////////////////////
  ///
  ///

  HomeRepositoryInterface localHomeRepositoryInterface = HomeRepository(
    Get.find(),
    prefs,
  );
  Get.lazyPut(() => localHomeRepositoryInterface);
  HomeServiceInterface localHomeServiceInterface = HomeService(Get.find());
  Get.lazyPut(() => localHomeServiceInterface);
 Get.put<HomeController>(
    HomeController(Get.find<HomeServiceInterface>()),
    permanent: true,
  );
  Get.lazyPut(() => HomeService(Get.find()));

  //////////// location  Service, Repository and Controller ////////////////////////////////
  ///
  ///
    LocationRepositoryInterface locationRepositoryInterface = LocationRepository(
    Get.find(),
    prefs,
  );
  Get.lazyPut(() => locationRepositoryInterface);
  LocationServiceInterface locationServiceInterface = Get.put<LocationServiceInterface>(LocationService(Get.find()));
  Get.lazyPut(() => localHomeServiceInterface);
  Get.lazyPut(() => LocationController());
  Get.lazyPut(() => LocationService(Get.find()));

}