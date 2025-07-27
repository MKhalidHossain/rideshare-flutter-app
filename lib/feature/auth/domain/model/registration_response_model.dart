class RegistrationResponseModel {
  int? statusCode;
  bool? success;
  String? message;
  Data? data;

  RegistrationResponseModel(
      {this.statusCode, this.success, this.message, this.data});

  RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? accessToken;
  String? refreshToken;
  String? userId;
  String? email;

  Data({this.accessToken, this.refreshToken, this.userId, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    userId = json['userId'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['userId'] = this.userId;
    data['email'] = this.email;
    return data;
  }
}
