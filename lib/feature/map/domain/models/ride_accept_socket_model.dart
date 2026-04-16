import 'dart:convert';

class RideAcceptSocketModel {
  final String rideId;
  final DriverInfo? driver;

  RideAcceptSocketModel({
    required this.rideId,
    this.driver,
  });

  factory RideAcceptSocketModel.fromSocket(dynamic raw) {
    Map<String, dynamic> data;

    if (raw is String) {
      data = Map<String, dynamic>.from(jsonDecode(raw));
    } else if (raw is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is Map) {
      data = raw.map((k, v) => MapEntry(k.toString(), v));
    } else {
      throw Exception(
          'Unsupported ride_accept payload type: ${raw.runtimeType}');
    }

    final driverMap = data['driver'] is Map
        ? Map<String, dynamic>.from(data['driver'])
        : <String, dynamic>{};

    return RideAcceptSocketModel(
      rideId: data['rideId']?.toString() ?? '',
      driver: driverMap.isNotEmpty ? DriverInfo.fromMap(driverMap) : null,
    );
  }
}

class DriverInfo {
  final String id;
  final String? name;
  final String? phone;
  final VehicleInfo? vehicle;
  final double? rating;
  final CurrentLocation? currentLocation;

  DriverInfo({
    required this.id,
    this.name,
    this.phone,
    this.vehicle,
    this.rating,
    this.currentLocation,
  });

  factory DriverInfo.fromMap(Map<String, dynamic> map) {
    final vehicleMap = map['vehicle'] is Map
        ? Map<String, dynamic>.from(map['vehicle'])
        : <String, dynamic>{};

    final locationMap = map['currentLocation'] is Map
        ? Map<String, dynamic>.from(map['currentLocation'])
        : <String, dynamic>{};

    return DriverInfo(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString(),
      phone: map['phone']?.toString(),
      vehicle: vehicleMap.isNotEmpty ? VehicleInfo.fromMap(vehicleMap) : null,
      rating: map['rating'] != null ? double.tryParse(map['rating'].toString()) : null,
      currentLocation:
          locationMap.isNotEmpty ? CurrentLocation.fromMap(locationMap) : null,
    );
  }
}

class VehicleInfo {
  final String id; // from "_id"
  final String? serviceId;
  final String? driverId;
  final String? taxiName;
  final String? model;
  final String? plateNumber;
  final String? color;
  final int? year;
  final String? vin;
  final bool? assignedDrivers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v; // from "__v"

  VehicleInfo({
    required this.id,
    this.serviceId,
    this.driverId,
    this.taxiName,
    this.model,
    this.plateNumber,
    this.color,
    this.year,
    this.vin,
    this.assignedDrivers,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory VehicleInfo.fromMap(Map<String, dynamic> map) {
    return VehicleInfo(
      id: map['_id']?.toString() ?? '',
      serviceId: map['serviceId']?.toString(),
      driverId: map['driverId']?.toString(),
      taxiName: map['taxiName']?.toString(),
      model: map['model']?.toString(),
      plateNumber: map['plateNumber']?.toString(),
      color: map['color']?.toString(),
      year: map['year'] is int ? map['year'] as int : (map['year'] as num?)?.toInt(),
      vin: map['vin']?.toString(),
      assignedDrivers: map['assignedDrivers'] is bool
          ? map['assignedDrivers'] as bool
          : (map['assignedDrivers'] != null
              ? map['assignedDrivers'].toString().toLowerCase() == 'true'
              : null),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
      v: map['__v'] is int ? map['__v'] as int : (map['__v'] as num?)?.toInt(),
    );
  }
}

class CurrentLocation {
  final String? type;
  final List<double> coordinates; // [lng, lat]

  CurrentLocation({
    this.type,
    required this.coordinates,
  });

  double? get lng => coordinates.isNotEmpty ? coordinates[0] : null;
  double? get lat => coordinates.length > 1 ? coordinates[1] : null;

  factory CurrentLocation.fromMap(Map<String, dynamic> map) {
    final rawCoords = map['coordinates'];

    final coords = <double>[];
    if (rawCoords is List) {
      for (final e in rawCoords) {
        if (e is num) {
          coords.add(e.toDouble());
        } else {
          final parsed = double.tryParse(e.toString());
          if (parsed != null) coords.add(parsed);
        }
      }
    }

    return CurrentLocation(
      type: map['type']?.toString(),
      coordinates: coords,
    );
  }
}
