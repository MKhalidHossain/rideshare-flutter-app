class CreatePaymentRequestModel {
  String? rideId;
  String? rideDuration;
  int? amount;
  String? stripeDriverId;
  String? driverId;

  CreatePaymentRequestModel({
    this.rideId,
    this.rideDuration,
    this.amount,
    this.stripeDriverId,
    this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      "rideId": rideId,
      "rideDuration": rideDuration,
      "amount": amount,
      "stripeDriverId": stripeDriverId,
      "driverId": driverId,
    };
  }
}
