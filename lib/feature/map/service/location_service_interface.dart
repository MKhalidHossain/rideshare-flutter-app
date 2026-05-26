import '../domain/models/place_prediction.dart';

abstract class LocationServiceInterface {
  Future<List<PlacePrediction>> searchPlaces({required String query});
}
