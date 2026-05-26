import 'package:rideztohealth/feature/map/domain/models/place_prediction.dart';
import 'package:rideztohealth/feature/map/repository/location_repository_interface.dart';
import 'package:rideztohealth/feature/map/service/location_service_interface.dart';

class LocationService implements LocationServiceInterface {
  final LocationRepositoryInterface locationRepositoryInterface;

  LocationService(this.locationRepositoryInterface);

  @override
  Future<List<PlacePrediction>> searchPlaces({required String query}) async {
    return await locationRepositoryInterface.searchPlaces(query: query);
  }
}
