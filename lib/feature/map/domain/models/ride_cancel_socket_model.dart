import 'dart:convert';

class RideCancelSocketModel {
  final String rideId;
  final String? cancelledBy; // e.g. "driver" / "customer" / "system"
  final String? reason;

  RideCancelSocketModel({
    required this.rideId,
    this.cancelledBy,
    this.reason,
  });

  factory RideCancelSocketModel.fromSocket(dynamic raw) {
    Map<String, dynamic> data;

    if (raw is String) {
      data = Map<String, dynamic>.from(jsonDecode(raw));
    } else if (raw is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is Map) {
      data = raw.map((k, v) => MapEntry(k.toString(), v));
    } else {
      throw Exception(
          'Unsupported ride_cancel payload type: ${raw.runtimeType}');
    }

    return RideCancelSocketModel(
      rideId: data['rideId']?.toString() ?? '',
      cancelledBy: data['cancelledBy']?.toString(),
      reason: data['reason']?.toString(),
    );
  }
}
