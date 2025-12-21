class RideBookingInfo {
  final String driverId;
  final Location pickupLocation;
  final Location dropoffLocation;
  final String totalFare;

  RideBookingInfo({
    required this.driverId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.totalFare,
  });

  factory RideBookingInfo.fromJson(Map<String, dynamic> json) {
    return RideBookingInfo(
      driverId: json['driverId'],
      pickupLocation: Location.fromJson(json['pickupLocation']),
      dropoffLocation: Location.fromJson(json['dropoffLocation']),
      totalFare: json['totalFare'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocation': dropoffLocation.toJson(),
      'totalFare': totalFare,
    };
  }
}

class Location {
  final List<double> coordinates;
  final String address;

  Location({
    required this.coordinates,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates,
      'address': address,
    };
  }
}
