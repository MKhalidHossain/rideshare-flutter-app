String? _normalizeStripeId(String? raw) {
  if (raw == null) return null;
  final value = raw.trim();
  return value.isEmpty ? null : value;
}

class GetSearchDestinationForFindNearestDriversResponseModel {
  final bool ?success;
  final String ?message;
  final List<NearestDriverData> ?data;

  GetSearchDestinationForFindNearestDriversResponseModel({
     this.success,
     this.message,
     this.data,
  });

  factory GetSearchDestinationForFindNearestDriversResponseModel.fromJson(
      Map<String, dynamic> json) {
    return GetSearchDestinationForFindNearestDriversResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => NearestDriverData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data!.map((e) => e.toJson()).toList(),
    };
  }
}

class NearestDriverData {
  final Driver driver;
  final Vehicle vehicle;
  final Service service;

  NearestDriverData({
    required this.driver,
    required this.vehicle,
    required this.service,
  });

  factory NearestDriverData.fromJson(Map<String, dynamic> json) {
    return NearestDriverData(
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      service: Service.fromJson(json['service'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver': driver.toJson(),
      'vehicle': vehicle.toJson(),
      'service': service.toJson(),
    };
  }
}

class Driver {
  final CurrentLocation currentLocation;
  final Earnings earnings;
  final Ratings ratings;
  final String id;
  final DriverUserId userId;
  final String vehicleId;
  final String status;
  final bool isAvailable;
  final num heading;
  final bool isOnline;
  final num speed;
  final num? accuracy;
  final List<dynamic> paymentMethods;
  final List<dynamic> withdrawals;
  final String? stripeDriverId;
  final int v;

  Driver({
    required this.currentLocation,
    required this.earnings,
    required this.ratings,
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.status,
    required this.isAvailable,
    required this.heading,
    required this.isOnline,
    required this.speed,
    this.accuracy,
    required this.paymentMethods,
    required this.withdrawals,
    this.stripeDriverId,
    required this.v,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      currentLocation:
          CurrentLocation.fromJson(json['currentLocation'] as Map<String, dynamic>),
      earnings: Earnings.fromJson(json['earnings'] as Map<String, dynamic>),
      ratings: Ratings.fromJson(json['ratings'] as Map<String, dynamic>),
      id: json['_id'] as String,
      userId: DriverUserId.fromJson(json['userId'] as Map<String, dynamic>),
      vehicleId: json['vehicleId'] as String,
      status: json['status'] as String,
      isAvailable: json['isAvailable'] as bool,
      heading: json['heading'] as num,
      isOnline: json['isOnline'] as bool,
      speed: json['speed'] as num,
      accuracy: json['accuracy'] as num?,
      paymentMethods: (json['paymentMethods'] as List<dynamic>?) ?? [],
      withdrawals: (json['withdrawals'] as List<dynamic>?) ?? [],
      stripeDriverId: _normalizeStripeId(
        json['stripeDriverId'] as String? ??
            json['stripe_account_id'] as String? ??
            json['stripeAccountId'] as String? ??
            json['stripeAccount'] as String? ??
            json['stripeId'] as String? ??
            json['stripe'] as String?,
      ),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLocation': currentLocation.toJson(),
      'earnings': earnings.toJson(),
      'ratings': ratings.toJson(),
      '_id': id,
      'userId': userId.toJson(),
      'vehicleId': vehicleId,
      'status': status,
      'isAvailable': isAvailable,
      'heading': heading,
      'isOnline': isOnline,
      'speed': speed,
      'accuracy': accuracy,
      'paymentMethods': paymentMethods,
      'withdrawals': withdrawals,
      if (stripeDriverId != null) 'stripeDriverId': stripeDriverId,
      '__v': v,
    };
  }

  String? get payoutAccountId =>
      stripeDriverId ?? userId.payoutAccountId;
}

class CurrentLocation {
  final String type;
  final List<double> coordinates;

  CurrentLocation({
    required this.type,
    required this.coordinates,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class Earnings {
  final num total;
  final num available;
  final num withdrawn;

  Earnings({
    required this.total,
    required this.available,
    required this.withdrawn,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      total: json['total'] as num,
      available: json['available'] as num,
      withdrawn: json['withdrawn'] as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'available': available,
      'withdrawn': withdrawn,
    };
  }
}

class Ratings {
  final num average;
  final int count1;
  final int count2;
  final int count3;
  final int count4;
  final int count5;
  final int totalRatings;

  Ratings({
    required this.average,
    required this.count1,
    required this.count2,
    required this.count3,
    required this.count4,
    required this.count5,
    required this.totalRatings,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      average: json['average'] as num,
      count1: json['count1'] as int,
      count2: json['count2'] as int,
      count3: json['count3'] as int,
      count4: json['count4'] as int,
      count5: json['count5'] as int,
      totalRatings: json['totalRatings'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count1': count1,
      'count2': count2,
      'count3': count3,
      'count4': count4,
      'count5': count5,
      'totalRatings': totalRatings,
    };
  }
}

class DriverUserId {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? profileImage;
  final String? stripeAccountId;

  DriverUserId({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.profileImage,
    this.stripeAccountId,
  });

  factory DriverUserId.fromJson(Map<String, dynamic> json) {
    return DriverUserId(
      id: json['_id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      profileImage: json['profileImage'] as String?,
      stripeAccountId: _normalizeStripeId(
        json['stripeAccountId'] as String? ??
            json['stripe_account_id'] as String? ??
            json['stripeAccount'] as String? ??
            json['stripeId'] as String? ??
            json['stripe'] as String?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      if (stripeAccountId != null) 'stripeAccountId': stripeAccountId,
    };
  }

  String? get payoutAccountId => stripeAccountId;
}

class Vehicle {
  final String id;
  final String serviceId;
  final String driverId;
  final String taxiName;
  final String model;
  final String plateNumber;
  final String color;
  final int year;
  final String vin;
  final bool assignedDrivers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Vehicle({
    required this.id,
    required this.serviceId,
    required this.driverId,
    required this.taxiName,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.year,
    required this.vin,
    required this.assignedDrivers,
    this.createdAt,
    this.updatedAt,
    required this.v,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] as String,
      serviceId: json['serviceId'] as String,
      driverId: json['driverId'] as String,
      taxiName: json['taxiName'] as String,
      model: json['model'] as String,
      plateNumber: json['plateNumber'] as String,
      color: json['color'] as String,
      year: json['year'] as int,
      vin: json['vin'] as String,
      assignedDrivers: json['assignedDrivers'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'serviceId': serviceId,
      'driverId': driverId,
      'taxiName': taxiName,
      'model': model,
      'plateNumber': plateNumber,
      'color': color,
      'year': year,
      'vin': vin,
      'assignedDrivers': assignedDrivers,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class Service {
  final String id;
  final String name;
  final String description;
  final num baseFare;
  final String serviceImage;
  final num perKmRate;
  final num perMinuteRate;
  final num minimumFare;
  final num cancellationFee;
  final int capacity;
  final bool isActive;
  final List<dynamic> features;
  final int estimatedArrivalTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.serviceImage,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.minimumFare,
    required this.cancellationFee,
    required this.capacity,
    required this.isActive,
    required this.features,
    required this.estimatedArrivalTime,
    this.createdAt,
    this.updatedAt,
    required this.v,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      baseFare: json['baseFare'] as num,
      serviceImage: json['serviceImage'] as String,
      perKmRate: json['perKmRate'] as num,
      perMinuteRate: json['perMinuteRate'] as num,
      minimumFare: json['minimumFare'] as num,
      cancellationFee: json['cancellationFee'] as num,
      capacity: json['capacity'] as int,
      isActive: json['isActive'] as bool,
      features: (json['features'] as List<dynamic>?) ?? [],
      estimatedArrivalTime: json['estimatedArrivalTime'] as int,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'baseFare': baseFare,
      'serviceImage': serviceImage,
      'perKmRate': perKmRate,
      'perMinuteRate': perMinuteRate,
      'minimumFare': minimumFare,
      'cancellationFee': cancellationFee,
      'capacity': capacity,
      'isActive': isActive,
      'features': features,
      'estimatedArrivalTime': estimatedArrivalTime,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}
