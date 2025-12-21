class CreatePaymentRequestModel {
  int? amount;
  String? stripeDriverId;
  String? driverId;

  CreatePaymentRequestModel({
    this.amount,
    this.stripeDriverId,
    this.driverId,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "stripeDriverId": stripeDriverId,
      "driverId": driverId,
    };
  }
}
