class CreatePaymentResponseModel {
  final bool? success;
  final String? url;
  final String? sessionId;
  final Breakdown? breakdown;

  CreatePaymentResponseModel({
    this.success,
    this.url,
    this.sessionId,
    this.breakdown,
  });

  factory CreatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePaymentResponseModel(
      success: json['success'] as bool?,
      url: json['url'] as String?,
      sessionId: json['sessionId'] as String?,
      breakdown: json['breakdown'] != null
          ? Breakdown.fromJson(json['breakdown'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'url': url,
      'sessionId': sessionId,
      if (breakdown != null) 'breakdown': breakdown!.toJson(),
    };
  }
}

class Breakdown {
  final int? total;
  final int? adminFee;
  final int? driverAmount;

  Breakdown({this.total, this.adminFee, this.driverAmount});

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    return Breakdown(
      total: _toInt(json['total']),
      adminFee: _toInt(json['adminFee']),
      driverAmount: _toInt(json['driverAmount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'adminFee': adminFee,
      'driverAmount': driverAmount,
    };
  }

  /// Safely converts dynamic to int? (handles int, double, String, null)
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
