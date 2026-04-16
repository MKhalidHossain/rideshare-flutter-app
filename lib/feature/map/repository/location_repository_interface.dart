
import 'package:get/get_connect/http/src/response/response.dart';
import '../domain/models/place_prediction.dart';

abstract class LocationRepositoryInterface {

  // FutureRequest<Success<LocationAdress>> getAddressFromLatLng({required Coordinate latLng});

  Future<List<PlacePrediction>> searchPlaces({required String query}); 




  // FutureRequest<Success<Coordinate>> getCurrentLocation();

  // FutureRequest<Success<PlaceDetails>> getPlaceDetails(String placeId);

}