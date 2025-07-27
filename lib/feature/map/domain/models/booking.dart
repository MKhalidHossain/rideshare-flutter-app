import '../../controllers/booking_controller.dart';


class Booking {
  final String id;
  final String pickupAddress;
  final String destinationAddress;
  final CarType carType;
  final String paymentMethod;
  final double estimatedPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? driverId;
  final double? actualPrice;
  final double? distance;
  final int? duration;
  final double? driverRating;
  final String? notes;

  Booking({
    required this.id,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.carType,
    required this.paymentMethod,
    required this.estimatedPrice,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.driverId,
    this.actualPrice,
    this.distance,
    this.duration,
    this.driverRating,
    this.notes,
  });

  Booking copyWith({
    String? id,
    String? pickupAddress,
    String? destinationAddress,
    CarType? carType,
    String? paymentMethod,
    double? estimatedPrice,
    BookingStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? driverId,
    double? actualPrice,
    double? distance,
    int? duration,
    double? driverRating,
    String? notes,
  }) {
    return Booking(
      id: id ?? this.id,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      carType: carType ?? this.carType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      driverId: driverId ?? this.driverId,
      actualPrice: actualPrice ?? this.actualPrice,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      driverRating: driverRating ?? this.driverRating,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pickupAddress': pickupAddress,
      'destinationAddress': destinationAddress,
      'carType': carType.toString(),
      'paymentMethod': paymentMethod,
      'estimatedPrice': estimatedPrice,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'driverId': driverId,
      'actualPrice': actualPrice,
      'distance': distance,
      'duration': duration,
      'driverRating': driverRating,
      'notes': notes,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      pickupAddress: json['pickupAddress'],
      destinationAddress: json['destinationAddress'],
      carType: CarType.values.firstWhere(
        (e) => e.toString() == json['carType'],
        orElse: () => CarType.economy,
      ),
      paymentMethod: json['paymentMethod'],
      estimatedPrice: json['estimatedPrice'].toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => BookingStatus.searching,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      confirmedAt: json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt']) : null,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      driverId: json['driverId'],
      actualPrice: json['actualPrice']?.toDouble(),
      distance: json['distance']?.toDouble(),
      duration: json['duration'],
      driverRating: json['driverRating']?.toDouble(),
      notes: json['notes'],
    );
  }

  String get carTypeString {
    switch (carType) {
      case CarType.economy:
        return 'Economy';
      case CarType.comfort:
        return 'Comfort';
      case CarType.premium:
        return 'Premium';
      case CarType.luxury:
        return 'Luxury';
    }
  }

  String get statusString {
    switch (status) {
      case BookingStatus.searching:
        return 'Searching for driver';
      case BookingStatus.confirmed:
        return 'Booking confirmed';
      case BookingStatus.driverAssigned:
        return 'Driver assigned';
      case BookingStatus.inProgress:
        return 'Trip in progress';
      case BookingStatus.completed:
        return 'Trip completed';
      case BookingStatus.cancelled:
        return 'Booking cancelled';
    }
  }

  bool get isActive {
    return status == BookingStatus.confirmed ||
           status == BookingStatus.driverAssigned ||
           status == BookingStatus.inProgress;
  }

  bool get isCompleted {
    return status == BookingStatus.completed;
  }

  bool get isCancelled {
    return status == BookingStatus.cancelled;
  }

  Duration? get totalDuration {
    if (startedAt != null && completedAt != null) {
      return completedAt!.difference(startedAt!);
    }
    return null;
  }

  @override
  String toString() {
    return 'Booking(id: $id, from: $pickupAddress, to: $destinationAddress, status: $statusString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}