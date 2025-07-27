class ResetPasswordResponseModel {
  int? statusCode;
  bool? success;
  String? message;

  ResetPasswordResponseModel({this.statusCode, this.success, this.message});

  ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
