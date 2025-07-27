import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../controllers/booking_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/locaion_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize all controllers immediately and keep them in memory
    Get.put(AppController(), permanent: true);
    Get.put(LocationController(), permanent: true);
    Get.put(BookingController(), permanent: true);
    Get.put(ChatController(), permanent: true);
  }
}




// import 'package:get/get.dart';

// import '../controllers/app_controller.dart';
// import '../controllers/booking_controller.dart';
// import '../controllers/chat_controller.dart';
// import '../controllers/locaion_controller.dart';
// class InitialBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Put all controllers as permanent to maintain state across navigation
//     Get.put<AppController>(AppController(), permanent: true);
//     Get.put<LocationController>(LocationController(), permanent: true);
//     Get.put<BookingController>(BookingController(), permanent: true);
//     Get.put<ChatController>(ChatController(), permanent: true);
//   }
// }