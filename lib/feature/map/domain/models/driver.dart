class Driver {
  final String id;
  final String name;
  final String phone;
  final double rating;
  final String carModel;
  final String carColor;
  final String licensePlate;
  final String profileImage;
  final bool isOnline;
  final DateTime? lastSeen;
  final int totalTrips;
  final int yearsExperience;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.carModel,
    required this.carColor,
    required this.licensePlate,
    required this.profileImage,
    this.isOnline = true,
    this.lastSeen,
    this.totalTrips = 0,
    this.yearsExperience = 0,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? phone,
    double? rating,
    String? carModel,
    String? carColor,
    String? licensePlate,
    String? profileImage,
    bool? isOnline,
    DateTime? lastSeen,
    int? totalTrips,
    int? yearsExperience,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      carModel: carModel ?? this.carModel,
      carColor: carColor ?? this.carColor,
      licensePlate: licensePlate ?? this.licensePlate,
      profileImage: profileImage ?? this.profileImage,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      totalTrips: totalTrips ?? this.totalTrips,
      yearsExperience: yearsExperience ?? this.yearsExperience,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'rating': rating,
      'carModel': carModel,
      'carColor': carColor,
      'licensePlate': licensePlate,
      'profileImage': profileImage,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      'totalTrips': totalTrips,
      'yearsExperience': yearsExperience,
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      rating: json['rating'].toDouble(),
      carModel: json['carModel'],
      carColor: json['carColor'],
      licensePlate: json['licensePlate'],
      profileImage: json['profileImage'],
      isOnline: json['isOnline'] ?? true,
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
      totalTrips: json['totalTrips'] ?? 0,
      yearsExperience: json['yearsExperience'] ?? 0,
    );
  }

  String get fullCarInfo => '$carColor $carModel ($licensePlate)';
  
  String get ratingString => rating.toStringAsFixed(1);
  
  bool get isHighRated => rating >= 4.5;
  
  String get experienceString {
    if (yearsExperience == 0) return 'New driver';
    if (yearsExperience == 1) return '1 year experience';
    return '$yearsExperience years experience';
  }

  @override
  String toString() {
    return 'Driver(id: $id, name: $name, rating: $rating, car: $fullCarInfo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Driver && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}