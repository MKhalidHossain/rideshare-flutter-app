class CreateRidePaymentRequest {
  final int amount;
  final String stripeDriverId;
  final String driverId;

  CreateRidePaymentRequest({
    required this.amount,
    required this.stripeDriverId,
    required this.driverId,
  });

  factory CreateRidePaymentRequest.fromJson(Map<String, dynamic> json) {
    return CreateRidePaymentRequest(
      amount: json['amount'] as int,
      stripeDriverId: json['stripeDriverId'] as String,
      driverId: json['driverId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'stripeDriverId': stripeDriverId,
      'driverId': driverId,
    };
  }
}
