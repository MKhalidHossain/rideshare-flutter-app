class AddSavedPlacesResponseModel {
  final bool? success;
  final String? message;
  final List<SavedPlace>? data;

  const AddSavedPlacesResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory AddSavedPlacesResponseModel.fromJson(Map<String, dynamic> json) {
    return AddSavedPlacesResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SavedPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class SavedPlace {
  final String? name;
  final String? address;
  final List<double>? coordinates; // [longitude, latitude]
  final String? type;
  final String? id;

  const SavedPlace({
    this.name,
    this.address,
    this.coordinates,
    this.type,
    this.id,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      name: json['name'] as String?,
      address: json['address'] as String?,
      // ✅ handles ints/doubles safely (num -> double)
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'coordinates': coordinates,
        'type': type,
        '_id': id,
      };
}
