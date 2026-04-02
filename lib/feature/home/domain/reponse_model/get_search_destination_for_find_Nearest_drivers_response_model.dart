String? _normalizeStripeId(String? raw) {
  if (raw == null) return null;
  final value = raw.trim();
  return value.isEmpty ? null : value;
}

/// Safe helpers (prevents "Null is not subtype of Map<String,dynamic>" forever)
Map<String, dynamic>? _asMap(dynamic v) => v is Map<String, dynamic> ? v : null;
List _asList(dynamic v) => v is List ? v : const [];
String _asString(dynamic v, {String fallback = ''}) =>
    v is String ? v : fallback;
bool _asBool(dynamic v, {bool fallback = false}) => v is bool ? v : fallback;
int _asInt(dynamic v, {int fallback = 0}) =>
    v is int ? v : (v is num ? v.toInt() : fallback);
num _asNum(dynamic v, {num fallback = 0}) => v is num ? v : fallback;

DateTime? _asDateTime(dynamic v) {
  if (v is String && v.isNotEmpty) {
    try {
      return DateTime.parse(v);
    } catch (_) {
      return null;
    }
  }
  return null;
}

class GetSearchDestinationForFindNearestDriversResponseModel {
  final bool? success;
  final String? message;
  final List<NearestDriverData>? data;

  GetSearchDestinationForFindNearestDriversResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetSearchDestinationForFindNearestDriversResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    return GetSearchDestinationForFindNearestDriversResponseModel(
      success: _asBool(json['success']),
      message: _asString(json['message']),
      data: rawData is List
          ? rawData
                .whereType<Map<String, dynamic>>()
                .map(NearestDriverData.fromJson)
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data!.map((e) => e.toJson()).toList(),
  };
}

class NearestDriverData {
  final Driver driver;
  final Vehicle? vehicle;
  final Service? service;
  final Commission? commission;

  NearestDriverData({
    required this.driver,
    this.vehicle,
    this.service,
    this.commission,
  });

  factory NearestDriverData.fromJson(Map<String, dynamic> json) {
    final driverMap = _asMap(json['driver']);
    final vehicleMap = _asMap(json['vehicle']);
    final serviceMap = _asMap(json['service']);
    final commissionMap = _asMap(json['commission']);

    return NearestDriverData(
      driver: driverMap != null ? Driver.fromJson(driverMap) : Driver.empty(),
      vehicle: vehicleMap != null ? Vehicle.fromJson(vehicleMap) : null,
      service: serviceMap != null ? Service.fromJson(serviceMap) : null,
      commission: commissionMap != null
          ? Commission.fromJson(commissionMap)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'driver': driver.toJson(),
    if (vehicle != null) 'vehicle': vehicle!.toJson(),
    if (service != null) 'service': service!.toJson(),
    if (commission != null) 'commission': commission!.toJson(),
  };
}

class Driver {
  final CurrentLocation currentLocation;
  final Earnings earnings;
  final Ratings ratings;
  final String id;

  /// ✅ API can send userId: null
  final DriverUserId? userId;

  final String vehicleId;
  final String status;
  final bool isAvailable;
  final num heading;
  final bool isOnline;
  final num speed;
  final num? accuracy;
  final List paymentMethods;
  final List withdrawals;
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
    required this.accuracy,
    required this.paymentMethods,
    required this.withdrawals,
    required this.stripeDriverId,
    required this.v,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    final userMap = _asMap(json['userId']);

    return Driver(
      currentLocation: CurrentLocation.fromJson(
        _asMap(json['currentLocation']) ?? const {},
      ),
      earnings: Earnings.fromJson(_asMap(json['earnings']) ?? const {}),
      ratings: Ratings.fromJson(_asMap(json['ratings']) ?? const {}),
      id: _asString(json['_id']),
      userId: userMap != null ? DriverUserId.fromJson(userMap) : null, // ✅ safe
      vehicleId: _asString(json['vehicleId']),
      status: _asString(json['status']),
      isAvailable: _asBool(json['isAvailable']),
      heading: _asNum(json['heading']),
      isOnline: _asBool(json['isOnline']),
      speed: _asNum(json['speed']),
      accuracy: json['accuracy'] is num ? json['accuracy'] as num : null,
      paymentMethods: _asList(json['paymentMethods']),
      withdrawals: _asList(json['withdrawals']),
      stripeDriverId: _normalizeStripeId(
        json['stripeDriverId'] as String? ??
            json['stripe_account_id'] as String? ??
            json['stripeAccountId'] as String? ??
            json['stripeAccount'] as String? ??
            json['stripeId'] as String? ??
            json['stripe'] as String?,
      ),
      v: _asInt(json['__v']),
    );
  }

  factory Driver.empty() => Driver(
    currentLocation: CurrentLocation.empty(),
    earnings: Earnings.empty(),
    ratings: Ratings.empty(),
    id: '',
    userId: null,
    vehicleId: '',
    status: '',
    isAvailable: false,
    heading: 0,
    isOnline: false,
    speed: 0,
    accuracy: null,
    paymentMethods: const [],
    withdrawals: const [],
    stripeDriverId: null,
    v: 0,
  );

  Map<String, dynamic> toJson() => {
    'currentLocation': currentLocation.toJson(),
    'earnings': earnings.toJson(),
    'ratings': ratings.toJson(),
    '_id': id,
    'userId': userId?.toJson(), // ✅ safe
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

  String? get payoutAccountId => stripeDriverId ?? userId?.payoutAccountId;
}

class CurrentLocation {
  final String type;
  final List<double> coordinates;

  CurrentLocation({required this.type, required this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'];
    return CurrentLocation(
      type: _asString(json['type']),
      coordinates: coords is List
          ? coords
                .where((e) => e is num)
                .map((e) => (e as num).toDouble())
                .toList()
          : const [],
    );
  }

  factory CurrentLocation.empty() =>
      CurrentLocation(type: '', coordinates: const []);

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
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

  factory Earnings.fromJson(Map<String, dynamic> json) => Earnings(
    total: _asNum(json['total']),
    available: _asNum(json['available']),
    withdrawn: _asNum(json['withdrawn']),
  );

  factory Earnings.empty() => Earnings(total: 0, available: 0, withdrawn: 0);

  Map<String, dynamic> toJson() => {
    'total': total,
    'available': available,
    'withdrawn': withdrawn,
  };
}

class Ratings {
  final num average;
  final int count1;
  final int count2;
  final int count3;
  final int count4;
  final int count5;
  final int totalRatings;

  /// ✅ your API has "reviews": []
  final List reviews;

  Ratings({
    required this.average,
    required this.count1,
    required this.count2,
    required this.count3,
    required this.count4,
    required this.count5,
    required this.totalRatings,
    required this.reviews,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
    average: _asNum(json['average']),
    count1: _asInt(json['count1']),
    count2: _asInt(json['count2']),
    count3: _asInt(json['count3']),
    count4: _asInt(json['count4']),
    count5: _asInt(json['count5']),
    totalRatings: _asInt(json['totalRatings']),
    reviews: _asList(json['reviews']),
  );

  factory Ratings.empty() => Ratings(
    average: 0,
    count1: 0,
    count2: 0,
    count3: 0,
    count4: 0,
    count5: 0,
    totalRatings: 0,
    reviews: const [],
  );

  Map<String, dynamic> toJson() => {
    'average': average,
    'count1': count1,
    'count2': count2,
    'count3': count3,
    'count4': count4,
    'count5': count5,
    'totalRatings': totalRatings,
    'reviews': reviews,
  };
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

  factory DriverUserId.fromJson(Map<String, dynamic> json) => DriverUserId(
    id: _asString(json['_id']),
    fullName: _asString(json['fullName']),
    phoneNumber: _asString(json['phoneNumber']),
    profileImage: json['profileImage'] is String
        ? json['profileImage'] as String
        : null,
    stripeAccountId: _normalizeStripeId(
      json['stripeAccountId'] as String? ??
          json['stripe_account_id'] as String? ??
          json['stripeAccount'] as String? ??
          json['stripeId'] as String? ??
          json['stripe'] as String?,
    ),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'profileImage': profileImage,
    if (stripeAccountId != null) 'stripeAccountId': stripeAccountId,
  };

  String? get payoutAccountId => stripeAccountId;
}

class Vehicle {
  final String id;
  final String serviceId;
  final String? driverId;
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

  /// ✅ your API sometimes sends this null
  final String? serviceImage;

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
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.serviceImage,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    id: _asString(json['_id']),
    serviceId: _asString(json['serviceId']),
    driverId: json['driverId'] is String ? json['driverId'] as String : null,
    taxiName: _asString(json['taxiName']),
    model: _asString(json['model']),
    plateNumber: _asString(json['plateNumber']),
    color: _asString(json['color']),
    year: _asInt(json['year']),
    vin: _asString(json['vin']),
    assignedDrivers: _asBool(json['assignedDrivers']),
    createdAt: _asDateTime(json['createdAt']),
    updatedAt: _asDateTime(json['updatedAt']),
    v: _asInt(json['__v']),
    serviceImage: json['serviceImage'] is String
        ? json['serviceImage'] as String
        : null,
  );

  Map<String, dynamic> toJson() => {
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
    'serviceImage': serviceImage,
    '__v': v,
  };
}

class Service {
  static const double _ratePerMileFactor = 1.609344;

  final String id;
  final String name;
  final String description;
  final num baseFare;

  /// ✅ make nullable (future proof)
  final String? serviceImage;

  final num legacyRate;
  final num perMinuteRate;
  final num minimumFare;
  final num cancellationFee;
  final int capacity;
  final bool isActive;
  final List features;
  final int estimatedArrivalTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  /// ✅ API has perMileRate too (keep optional so no crash)
  final num? perMileRate;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.serviceImage,
    required this.legacyRate,
    required this.perMinuteRate,
    required this.minimumFare,
    required this.cancellationFee,
    required this.capacity,
    required this.isActive,
    required this.features,
    required this.estimatedArrivalTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.perMileRate,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: _asString(json['_id']),
    name: _asString(json['name']),
    description: _asString(json['description']),
    baseFare: _asNum(json['baseFare']),
    serviceImage: json['serviceImage'] is String
        ? json['serviceImage'] as String
        : null,
    legacyRate: _asNum(json['perKmRate']),
    perMinuteRate: _asNum(json['perMinuteRate']),
    minimumFare: _asNum(json['minimumFare']),
    cancellationFee: _asNum(json['cancellationFee']),
    capacity: _asInt(json['capacity']),
    isActive: _asBool(json['isActive']),
    features: _asList(json['features']),
    estimatedArrivalTime: _asInt(json['estimatedArrivalTime']),
    createdAt: _asDateTime(json['createdAt']),
    updatedAt: _asDateTime(json['updatedAt']),
    v: _asInt(json['__v']),
    perMileRate: json['perMileRate'] is num ? json['perMileRate'] as num : null,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
    'baseFare': baseFare,
    'serviceImage': serviceImage,
    'perKmRate': legacyRate,
    'perMinuteRate': perMinuteRate,
    'minimumFare': minimumFare,
    'cancellationFee': cancellationFee,
    'capacity': capacity,
    'isActive': isActive,
    'features': features,
    'estimatedArrivalTime': estimatedArrivalTime,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    if (perMileRate != null) 'perMileRate': perMileRate,
    '__v': v,
  };

  double get effectivePerMileRate =>
      (perMileRate ?? (legacyRate * _ratePerMileFactor)).toDouble();
}

class Commission {
  final String? id;
  final String? title;
  final String? description;
  final String? discountType;
  final num? commission;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final int? usedCount;
  final String? applicableServices;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdAt;
  final int? v;

  Commission({
    this.id,
    this.title,
    this.description,
    this.discountType,
    this.commission,
    this.startDate,
    this.endDate,
    this.status,
    this.usedCount,
    this.applicableServices,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.v,
  });

  factory Commission.fromJson(Map<String, dynamic> json) => Commission(
    id: _asString(json['_id']),
    title: _asString(json['title']),
    description: _asString(json['description']),
    discountType: _asString(json['discountType']),
    commission: json['commission'] is num ? json['commission'] as num : null,
    startDate: _asDateTime(json['startDate']),
    endDate: _asDateTime(json['endDate']),
    status: _asString(json['status']),
    usedCount: json['usedCount'] is int ? json['usedCount'] as int : null,
    applicableServices: _asString(json['applicableServices']),
    isActive: json['isActive'] is bool ? json['isActive'] as bool : null,
    createdBy: _asString(json['createdBy']),
    createdAt: _asDateTime(json['createdAt']),
    v: json['__v'] is int ? json['__v'] as int : null,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'title': title,
    'description': description,
    'discountType': discountType,
    'commission': commission,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'status': status,
    'usedCount': usedCount,
    'applicableServices': applicableServices,
    'isActive': isActive,
    'createdBy': createdBy,
    'createdAt': createdAt?.toIso8601String(),
    '__v': v,
  };
}

// String? _normalizeStripeId(String? raw) {
//   if (raw == null) return null;
//   final value = raw.trim();
//   return value.isEmpty ? null : value;
// }

// class GetSearchDestinationForFindNearestDriversResponseModel {
//   final bool? success;
//   final String? message;
//   final List<NearestDriverData>? data;

//   GetSearchDestinationForFindNearestDriversResponseModel({
//     this.success,
//     this.message,
//     this.data,
//   });

//   factory GetSearchDestinationForFindNearestDriversResponseModel.fromJson(
//       Map<String, dynamic> json) {
//     return GetSearchDestinationForFindNearestDriversResponseModel(
//       success: json['success'] as bool?,
//       message: json['message'] as String?,
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => NearestDriverData.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class NearestDriverData {
//   final Driver driver;
//   final Vehicle? vehicle;
//   final Service ?service;

//   NearestDriverData({
//     required this.driver,
//      this.vehicle,
//      this.service,
//   });

//   factory NearestDriverData.fromJson(Map<String, dynamic> json) {
//     return NearestDriverData(
//       driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
//       vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
//       service: Service.fromJson(json['service'] as Map<String, dynamic>),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'driver': driver.toJson(),
//       if (vehicle != null) 'vehicle': vehicle?.toJson(),  // Only include if not null
//       if (service != null) 'service': service?.toJson(),  // Only include if not null
//     };
//   }
// }

// class Driver {
//   final CurrentLocation currentLocation;
//   final Earnings earnings;
//   final Ratings ratings;
//   final String id;
//   final DriverUserId userId;
//   final String vehicleId;
//   final String status;
//   final bool isAvailable;
//   final num heading;
//   final bool isOnline;
//   final num speed;
//   final num? accuracy;
//   final List<dynamic> paymentMethods;
//   final List<dynamic> withdrawals;
//   final String? stripeDriverId;
//   final int v;

//   Driver({
//     required this.currentLocation,
//     required this.earnings,
//     required this.ratings,
//     required this.id,
//     required this.userId,
//     required this.vehicleId,
//     required this.status,
//     required this.isAvailable,
//     required this.heading,
//     required this.isOnline,
//     required this.speed,
//     this.accuracy,
//     required this.paymentMethods,
//     required this.withdrawals,
//     this.stripeDriverId,
//     required this.v,
//   });

//   factory Driver.fromJson(Map<String, dynamic> json) {
//     return Driver(
//       currentLocation:
//           CurrentLocation.fromJson(json['currentLocation'] as Map<String, dynamic>),
//       earnings: Earnings.fromJson(json['earnings'] as Map<String, dynamic>),
//       ratings: Ratings.fromJson(json['ratings'] as Map<String, dynamic>),
//       id: json['_id'] as String,
//       userId: DriverUserId.fromJson(json['userId'] as Map<String, dynamic>),
//       vehicleId: json['vehicleId'] as String,
//       status: json['status'] as String,
//       isAvailable: json['isAvailable'] as bool,
//       heading: json['heading'] as num,
//       isOnline: json['isOnline'] as bool,
//       speed: json['speed'] as num,
//       accuracy: json['accuracy'] as num?,
//       paymentMethods: (json['paymentMethods'] as List<dynamic>?) ?? [],
//       withdrawals: (json['withdrawals'] as List<dynamic>?) ?? [],
//       stripeDriverId: _normalizeStripeId(
//         json['stripeDriverId'] as String? ??
//             json['stripe_account_id'] as String? ??
//             json['stripeAccountId'] as String? ??
//             json['stripeAccount'] as String? ??
//             json['stripeId'] as String? ??
//             json['stripe'] as String?,
//       ),
//       v: json['__v'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'currentLocation': currentLocation.toJson(),
//       'earnings': earnings.toJson(),
//       'ratings': ratings.toJson(),
//       '_id': id,
//       'userId': userId.toJson(),
//       'vehicleId': vehicleId,
//       'status': status,
//       'isAvailable': isAvailable,
//       'heading': heading,
//       'isOnline': isOnline,
//       'speed': speed,
//       'accuracy': accuracy,
//       'paymentMethods': paymentMethods,
//       'withdrawals': withdrawals,
//       if (stripeDriverId != null) 'stripeDriverId': stripeDriverId,
//       '__v': v,
//     };
//   }

//   String? get payoutAccountId => stripeDriverId ?? userId.payoutAccountId;
// }

// class CurrentLocation {
//   final String type;
//   final List<double> coordinates;

//   CurrentLocation({
//     required this.type,
//     required this.coordinates,
//   });

//   factory CurrentLocation.fromJson(Map<String, dynamic> json) {
//     return CurrentLocation(
//       type: json['type'] as String,
//       coordinates: (json['coordinates'] as List<dynamic>)
//           .map((e) => (e as num).toDouble())
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': coordinates,
//     };
//   }
// }

// class Earnings {
//   final num total;
//   final num available;
//   final num withdrawn;

//   Earnings({
//     required this.total,
//     required this.available,
//     required this.withdrawn,
//   });

//   factory Earnings.fromJson(Map<String, dynamic> json) {
//     return Earnings(
//       total: json['total'] as num,
//       available: json['available'] as num,
//       withdrawn: json['withdrawn'] as num,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'total': total,
//       'available': available,
//       'withdrawn': withdrawn,
//     };
//   }
// }

// class Ratings {
//   final num average;
//   final int count1;
//   final int count2;
//   final int count3;
//   final int count4;
//   final int count5;
//   final int totalRatings;

//   Ratings({
//     required this.average,
//     required this.count1,
//     required this.count2,
//     required this.count3,
//     required this.count4,
//     required this.count5,
//     required this.totalRatings,
//   });

//   factory Ratings.fromJson(Map<String, dynamic> json) {
//     return Ratings(
//       average: json['average'] as num,
//       count1: json['count1'] as int,
//       count2: json['count2'] as int,
//       count3: json['count3'] as int,
//       count4: json['count4'] as int,
//       count5: json['count5'] as int,
//       totalRatings: json['totalRatings'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'average': average,
//       'count1': count1,
//       'count2': count2,
//       'count3': count3,
//       'count4': count4,
//       'count5': count5,
//       'totalRatings': totalRatings,
//     };
//   }
// }

// class DriverUserId {
//   final String id;
//   final String fullName;
//   final String phoneNumber;
//   final String? profileImage;
//   final String? stripeAccountId;

//   DriverUserId({
//     required this.id,
//     required this.fullName,
//     required this.phoneNumber,
//     this.profileImage,
//     this.stripeAccountId,
//   });

//   factory DriverUserId.fromJson(Map<String, dynamic> json) {
//     return DriverUserId(
//       id: json['_id'] as String,
//       fullName: json['fullName'] as String,
//       phoneNumber: json['phoneNumber'] as String,
//       profileImage: json['profileImage'] as String?,
//       stripeAccountId: _normalizeStripeId(
//         json['stripeAccountId'] as String? ??
//             json['stripe_account_id'] as String? ??
//             json['stripeAccount'] as String? ??
//             json['stripeId'] as String? ??
//             json['stripe'] as String?,
//       ),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'fullName': fullName,
//       'phoneNumber': phoneNumber,
//       'profileImage': profileImage,
//       if (stripeAccountId != null) 'stripeAccountId': stripeAccountId,
//     };
//   }

//   String? get payoutAccountId => stripeAccountId;
// }

// class Vehicle {
//   final String id;
//   final String serviceId;
//   final String? driverId; // ✅ nullable
//   final String taxiName;
//   final String model;
//   final String plateNumber;
//   final String color;
//   final int year;
//   final String vin;
//   final bool assignedDrivers;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int v;

//   Vehicle({
//     required this.id,
//     required this.serviceId,
//     required this.driverId,
//     required this.taxiName,
//     required this.model,
//     required this.plateNumber,
//     required this.color,
//     required this.year,
//     required this.vin,
//     required this.assignedDrivers,
//     this.createdAt,
//     this.updatedAt,
//     required this.v,
//   });

//   factory Vehicle.fromJson(Map<String, dynamic> json) {
//     return Vehicle(
//       id: json['_id'] as String,
//       serviceId: json['serviceId'] as String,
//       driverId: json['driverId'] as String?, // ✅ safe for null
//       taxiName: json['taxiName'] as String,
//       model: json['model'] as String,
//       plateNumber: json['plateNumber'] as String,
//       color: json['color'] as String,
//       year: json['year'] as int,
//       vin: json['vin'] as String,
//       assignedDrivers: json['assignedDrivers'] as bool,
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'] as String)
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'] as String)
//           : null,
//       v: json['__v'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'serviceId': serviceId,
//       'driverId': driverId,
//       'taxiName': taxiName,
//       'model': model,
//       'plateNumber': plateNumber,
//       'color': color,
//       'year': year,
//       'vin': vin,
//       'assignedDrivers': assignedDrivers,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       '__v': v,
//     };
//   }
// }

// class Service {
//   final String id;
//   final String name;
//   final String description;
//   final num baseFare;
//   final String serviceImage;
//   final num legacyRate;
//   final num perMinuteRate;
//   final num minimumFare;
//   final num cancellationFee;
//   final int capacity;
//   final bool isActive;
//   final List<dynamic> features;
//   final int estimatedArrivalTime;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int v;

//   Service({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.baseFare,
//     required this.serviceImage,
//     required this.legacyRate,
//     required this.perMinuteRate,
//     required this.minimumFare,
//     required this.cancellationFee,
//     required this.capacity,
//     required this.isActive,
//     required this.features,
//     required this.estimatedArrivalTime,
//     this.createdAt,
//     this.updatedAt,
//     required this.v,
//   });

//   factory Service.fromJson(Map<String, dynamic> json) {
//     return Service(
//       id: json['_id'] as String,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       baseFare: json['baseFare'] as num,
//       serviceImage: json['serviceImage'] as String,
//       legacyRate: json['perKmRate'] as num,
//       perMinuteRate: json['perMinuteRate'] as num,
//       minimumFare: json['minimumFare'] as num,
//       cancellationFee: json['cancellationFee'] as num,
//       capacity: json['capacity'] as int,
//       isActive: json['isActive'] as bool,
//       features: (json['features'] as List<dynamic>?) ?? [],
//       estimatedArrivalTime: json['estimatedArrivalTime'] as int,
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'] as String)
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'] as String)
//           : null,
//       v: json['__v'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'description': description,
//       'baseFare': baseFare,
//       'serviceImage': serviceImage,
//       'perKmRate': legacyRate,
//       'perMinuteRate': perMinuteRate,
//       'minimumFare': minimumFare,
//       'cancellationFee': cancellationFee,
//       'capacity': capacity,
//       'isActive': isActive,
//       'features': features,
//       'estimatedArrivalTime': estimatedArrivalTime,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       '__v': v,
//     };
//   }
// }
