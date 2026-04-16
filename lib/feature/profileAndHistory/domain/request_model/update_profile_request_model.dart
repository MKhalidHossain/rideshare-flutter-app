class UpdateProfileRequestModel {
  final String fullName;
  final String country;
  final String city;

  UpdateProfileRequestModel({
    required this.fullName,
    required this.country,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'country': country,
      'city': city,
    };
  }
}
