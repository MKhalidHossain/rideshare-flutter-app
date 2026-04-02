class GetAllServicesResponseModel {
  final bool? success;
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final List<ServiceData>? data;

  GetAllServicesResponseModel({
    this.success,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.data,
  });

  factory GetAllServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllServicesResponseModel(
      success: json["success"],
      currentPage: json["currentPage"],
      totalPages: json["totalPages"],
      totalItems: json["totalItems"],
      data: json["data"] == null
          ? []
          : List<ServiceData>.from(
              json["data"].map((x) => ServiceData.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalItems": totalItems,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ServiceData {
  final String? id;
  final String? name;
  final String? description;
  final int? baseFare;
  final String? serviceImage;
  final num? legacyRate;
  final num? perMileRate;
  final num? perMinuteRate;
  final int? minimumFare;
  final int? cancellationFee;
  final int? capacity;
  final bool? isActive;
  final List<dynamic>? features;
  final int? estimatedArrivalTime;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  ServiceData({
    this.id,
    this.name,
    this.description,
    this.baseFare,
    this.serviceImage,
    this.legacyRate,
    this.perMileRate,
    this.perMinuteRate,
    this.minimumFare,
    this.cancellationFee,
    this.capacity,
    this.isActive,
    this.features,
    this.estimatedArrivalTime,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) => ServiceData(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    baseFare: json["baseFare"],
    serviceImage: json["serviceImage"],
    legacyRate: json["perKmRate"] is num ? json["perKmRate"] as num : null,
    perMileRate: json["perMileRate"] is num ? json["perMileRate"] as num : null,
    perMinuteRate: json["perMinuteRate"] is num
        ? json["perMinuteRate"] as num
        : null,
    minimumFare: json["minimumFare"],
    cancellationFee: json["cancellationFee"],
    capacity: json["capacity"],
    isActive: json["isActive"],
    features: json["features"] ?? [],
    estimatedArrivalTime: json["estimatedArrivalTime"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "baseFare": baseFare,
    "serviceImage": serviceImage,
    "perKmRate": legacyRate,
    "perMileRate": perMileRate,
    "perMinuteRate": perMinuteRate,
    "minimumFare": minimumFare,
    "cancellationFee": cancellationFee,
    "capacity": capacity,
    "isActive": isActive,
    "features": features,
    "estimatedArrivalTime": estimatedArrivalTime,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}
