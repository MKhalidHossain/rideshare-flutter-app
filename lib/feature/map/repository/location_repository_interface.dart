
import '../domain/models/place_prediction.dart';

abstract class LocationRepositoryInterface {

  // FutureRequest<Success<LocationAdress>> getAddressFromLatLng({required Coordinate latLng});

  Future<List<PlacePrediction>> searchPlaces({required String query}); 




  // FutureRequest<Success<Coordinate>> getCurrentLocation();

  // FutureRequest<Success<PlaceDetails>> getPlaceDetails(String placeId);

}