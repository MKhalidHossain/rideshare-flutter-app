class ForgetPasswordResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  ForgetPasswordResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? email;
  int? otpExpiry;

  Data({this.email, this.otpExpiry});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otpExpiry = json['otpExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['otpExpiry'] = this.otpExpiry;
    return data;
  }
}
