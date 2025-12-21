import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/feature/home/domain/request_model/create_payment_response_model.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/add_saved_place_response_model.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/delete_saved_place_response_model.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_all_services_response_model.dart';
import 'package:rideztohealth/feature/home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import 'package:rideztohealth/feature/home/presentation/screens/home_screen.dart';
import 'package:rideztohealth/feature/payment/domain/create_payment_request_model.dart';
import '../domain/request_model/ride_booking_info_request_model.dart';
import '../domain/reponse_model/get_a_category_response_model.dart';
import '../domain/reponse_model/get_recent_trips_response_model.dart';
import '../domain/reponse_model/get_saved_places_response_model.dart';
import '../domain/reponse_model/request_ride_response_model.dart';
import '../services/home_service_interface.dart';


class HomeController extends GetxController implements GetxService {
  // final localHomeController = Get.find<LocalHomeController>();

  final HomeServiceInterface homeServiceInterface;

  HomeController(this.homeServiceInterface);

  GetAllServicesResponseModel getAllCategoryResponseModel =
      GetAllServicesResponseModel();
  GetACategoryResponseModel getACategoryResponseModel =
      GetACategoryResponseModel();

  AddSavedPlacesResponseModel addSavedPlacesResponseModel =
      AddSavedPlacesResponseModel();
  GetSavedPlacesResponseModel getSavedPlacesResponseModel =
      GetSavedPlacesResponseModel();
  DeleteSavedPlaceResponseModel deleteSavedPlaceResponseModel = 
      DeleteSavedPlaceResponseModel();

  Rx <GetRecentTripsResponseModel> getRecentTripsResponseModel =Rx<GetRecentTripsResponseModel>(GetRecentTripsResponseModel());

  GetSearchDestinationForFindNearestDriversResponseModel getSearchDestinationForFindNearestDriversResponseModel = 
      GetSearchDestinationForFindNearestDriversResponseModel();

  CreatePaymentResponseModel? createPaymentResponseModel;
  
  RequestRideResponseModel requestRideResponseModel = RequestRideResponseModel();


  bool isLoading = false;


Future<void> getAllServices() async {
  try {
    isLoading = true;
    update();

    final response = await homeServiceInterface.getAllServices();

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      debugPrint("✅ getAllServices: Categories fetched successfully.");
       // Ensure response.body is a Map before passing to fromJson
      // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      getAllCategoryResponseModel = GetAllServicesResponseModel.fromJson(response.body);

      isLoading = false;
      update();
    } else {
        getAllCategoryResponseModel = GetAllServicesResponseModel.fromJson(response.body);
    }
  } catch (e) {
    print("⚠️ Error fetching profile : getAllServices : $e\n");
  } finally {
    isLoading = false;
    update();
  }
}

Future<void> addSavedPlaces(String name , String addresss, double latitude, double longitude, String type) async {
  try {
    isLoading = true;
    update();

    final response = await homeServiceInterface.addSavedPlaces(name, addresss , latitude , longitude , type);

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      debugPrint("✅ addSavedPlaces: HomeController fetched successfully.");
       // Ensure response.body is a Map before passing to fromJson
      // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      addSavedPlacesResponseModel = AddSavedPlacesResponseModel.fromJson(response.body);

      isLoading = false;
      update();
    } else {
        addSavedPlacesResponseModel = AddSavedPlacesResponseModel.fromJson(response.body);
    }
  } catch (e) {
    print("⚠️ Error fetching HomeController : addSavedPlaces : $e\n");
  } finally {
    isLoading = false;
    update();
  }
}


Future<void> getSavedPlaces() async {
  try {
    isLoading = true;
    update();

    final response = await homeServiceInterface.getSavedPlaces();

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      debugPrint("✅ getSavedPlaces: HomeController fetched successfully.");
       // Ensure response.body is a Map before passing to fromJson
      // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      getSavedPlacesResponseModel = GetSavedPlacesResponseModel.fromJson(response.body);

      isLoading = false;
      update();
    } else {
        getSavedPlacesResponseModel = GetSavedPlacesResponseModel.fromJson(response.body);
    }
  } catch (e) {
    print("⚠️ Error fetching HomeController : getSavedPlaces : $e\n");
  } finally {
    isLoading = false;
    update();
  }
}


Future<void> deleteSavedPlaces(String placeId) async {
  try {
    isLoading = true;
    update();

    final response = await homeServiceInterface.deleteSavedPlaces(placeId);

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      debugPrint("✅ deleteSavedPlaces: HomeController fetched successfully.");
       // Ensure response.body is a Map before passing to fromJson
      // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      deleteSavedPlaceResponseModel = DeleteSavedPlaceResponseModel.fromJson(response.body);

      isLoading = false;
      update();
    } else {
        deleteSavedPlaceResponseModel = DeleteSavedPlaceResponseModel.fromJson(response.body);
    }
  } catch (e) {
    print("⚠️ Error fetching HomeController : deleteSavedPlaces : $e\n");
  } finally {
    isLoading = false;
    update();
  }
}

Future<void> getRecentTrips() async {
  try {
    isLoading = true;
    update();

    final response = await homeServiceInterface.getRecentTrips();

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body : getRecentTrips : ${response.body}");

    if (response.statusCode == 200) {
      debugPrint("✅ getRecentTrips: HomeController fetched successfully.");
       // Ensure response.body is a Map before passing to fromJson
      // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      getRecentTripsResponseModel.value = GetRecentTripsResponseModel.fromJson(response.body);
      print("this is for cheack form homeconteroller : ${getRecentTripsResponseModel.value.data?.rides?.first.driverId}");

      isLoading = false;
      update();
    } else {
      getRecentTripsResponseModel.value = GetRecentTripsResponseModel.fromJson(response.body);
    }

    
  } catch (e) {
    print("⚠️ Error fetching HomeController : getRecentTrips : $e\n");
  } finally {
    isLoading = false;
    update();
  }
}


  Future<void> getSearchDestinationForFindNearestDrivers(
  String latitude,
  String longitude,
) async {
  try {
    isLoading = true;
    update();

    final response = await homeServiceInterface
        .getSearchDestinationForFindNearestDrivers(latitude, longitude);

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode == 200 && response.body != null) {
      // If you're using GetConnect, body is already a decoded Map
      getSearchDestinationForFindNearestDriversResponseModel =
          GetSearchDestinationForFindNearestDriversResponseModel.fromJson(
        response.body,
      );

      debugPrint("✅ getSearchDestinationForFindNearestDrivers parsed successfully.");
    } else {
      // Don’t try to parse error response into your success model
      debugPrint("❌ API error (find rider): ${response.body}");
      // Here you can show a toast / snackbar using response.body['message']
    }
  } catch (e, st) {
    debugPrint(
        "⚠️ Error fetching HomeController : getSearchDestinationForFindNearestDrivers : $e\n$st");
  } finally {
    isLoading = false;
    update();
  }
}

  Future<RequestRideResponseModel> requestRide(
    RideBookingInfo requestModel,
  ) async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.requestRide(requestModel);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: from requestRide homecontroller :  ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedBody = _responseToMap(response.body);
        final parsedResponse = RequestRideResponseModel.fromJson(parsedBody);
        requestRideResponseModel = parsedResponse;
        return parsedResponse;
      }

      final message =
          _extractErrorMessage(response.body) ?? 'Unable to request ride';
      throw Exception(message);
    } catch (e) {
      debugPrint("⚠️ Error fetching HomeController : requestRide : $e\n");
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }


 Future<CreatePaymentResponseModel> createPayment(
    CreatePaymentRequestModel requestModel,
  ) async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.createPayment(requestModel);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedBody = _responseToMap(response.body);
        final parsedResponse =
            CreatePaymentResponseModel.fromJson(parsedBody);
        createPaymentResponseModel = parsedResponse;
        Get.to(HomeScreen());
        return parsedResponse;
      }

      final message =
          _extractErrorMessage(response.body) ?? 'Unable to create payment';
      throw Exception(message);
    } catch (e) {
      debugPrint(
        "⚠️ Error fetching HomeController : createPayment : $e\n",
      );
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

   Map<String, dynamic> _responseToMap(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body;
    }
    if (body is String && body.isNotEmpty) {
      return jsonDecode(body) as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

  String? _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body['message'] != null) {
        return body['message'].toString();
      }
      if (body['error'] != null) {
        return body['error'].toString();
      }
    } else if (body is String && body.isNotEmpty) {
      return body;
    }
    return null;
  }


// Future<void> getSearchDestinationForFindNearestDrivers(
//   String latitude,
//    String longitude
//    ) async {
//   try {
//     isLoading = true;
//     update();
//           print("this is for print forom car selection hiji biji 1");

//     final response = await homeServiceInterface.getSearchDestinationForFindNearestDrivers(latitude, longitude);

//     debugPrint("Status Code: ${response.statusCode}");
//     debugPrint("Response Body: ${response.body}");

// // 🔥 Always decode JSON first
//     final Map<String, dynamic> jsonResponse = jsonDecode(response.body);



//     if (response.statusCode == 200) {
//        debugPrint("✅ Parsed JSON: $jsonResponse");
//       debugPrint("✅ getSearchDestinationForFindNearestDrivers: HomeController fetched successfully.");
//        // Ensure response.body is a Map before passing to fromJson
//       // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
//       getSearchDestinationForFindNearestDriversResponseModel = GetSearchDestinationForFindNearestDriversResponseModel.fromJson(jsonResponse);

//       isLoading = false;
//       update();
//     } else {
//       getSearchDestinationForFindNearestDriversResponseModel = GetSearchDestinationForFindNearestDriversResponseModel.fromJson(jsonResponse);
//       update();
//     }
//   } catch (e) {
//     print("⚠️ Error fetching HomeController  : getSearchDestinationForFindNearestDrivers : $e\n");
//   } finally {
//     isLoading = false;
//     update();
//   }
// }



}
