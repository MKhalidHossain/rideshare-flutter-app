// AddSavePlaceResponseModel.dart
// JSON -> Dart models for the provided response shape.

class AddSavePlaceResponseModel {
  final bool ?success;
  final String? message;
  final List<SavedPlace> data;

  const AddSavePlaceResponseModel({
     this.success,
     this.message,
    required this.data,
  });

  factory AddSavePlaceResponseModel.fromJson(Map<String, dynamic> json) {
    return AddSavePlaceResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SavedPlace.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class SavedPlace {
  final String id;
  final String name;
  final String address;
  final List<double> coordinates; // [longitude, latitude]
  final String type;

  const SavedPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinates,
    required this.type,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> json) {
    return SavedPlace(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'address': address,
        'coordinates': coordinates,
        'type': type,
      };
}
