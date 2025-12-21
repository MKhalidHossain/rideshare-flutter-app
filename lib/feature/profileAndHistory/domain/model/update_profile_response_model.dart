import 'dart:convert';

UpdateProfileResponseModel updateProfileResponseModelFromJson(String str) =>
    UpdateProfileResponseModel.fromJson(json.decode(str));

String updateProfileResponseModelToJson(UpdateProfileResponseModel data) =>
    json.encode(data.toJson());

class UpdateProfileResponseModel {
  final bool? success;
  final String? message;
  final UserData? data;

  UpdateProfileResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? UserData.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserData {
  final CurrentLocation? currentLocation;
  final Wallet? wallet;
  final NotificationSettings? notificationSettings;
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final String? profileImage;
  final bool? isEmailVerified;
  final bool? isPhoneVerified;
  final String? refreshToken;
  final bool? isActive;
  final List<dynamic>? savedPlaces;
  final List<dynamic>? paymentMethods;
  final List<LoginHistory>? loginHistory;
  final String? createdAt;
  final int? v;

  UserData({
    this.currentLocation,
    this.wallet,
    this.notificationSettings,
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.role,
    this.profileImage,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.refreshToken,
    this.isActive,
    this.savedPlaces,
    this.paymentMethods,
    this.loginHistory,
    this.createdAt,
    this.v,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        currentLocation: json["currentLocation"] != null
            ? CurrentLocation.fromJson(json["currentLocation"])
            : null,
        wallet: json["wallet"] != null ? Wallet.fromJson(json["wallet"]) : null,
        notificationSettings: json["notificationSettings"] != null
            ? NotificationSettings.fromJson(json["notificationSettings"])
            : null,
        id: json["_id"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        role: json["role"],
        profileImage: json["profileImage"],
        isEmailVerified: json["isEmailVerified"],
        isPhoneVerified: json["isPhoneVerified"],
        refreshToken: json["refreshToken"],
        isActive: json["isActive"],
        savedPlaces: json["savedPlaces"] != null
            ? List<dynamic>.from(json["savedPlaces"].map((x) => x))
            : [],
        paymentMethods: json["paymentMethods"] != null
            ? List<dynamic>.from(json["paymentMethods"].map((x) => x))
            : [],
        loginHistory: json["loginHistory"] != null
            ? List<LoginHistory>.from(
                json["loginHistory"].map((x) => LoginHistory.fromJson(x)))
            : [],
        createdAt: json["createdAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "currentLocation": currentLocation?.toJson(),
        "wallet": wallet?.toJson(),
        "notificationSettings": notificationSettings?.toJson(),
        "_id": id,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "role": role,
        "profileImage": profileImage,
        "isEmailVerified": isEmailVerified,
        "isPhoneVerified": isPhoneVerified,
        "refreshToken": refreshToken,
        "isActive": isActive,
        "savedPlaces": savedPlaces != null
            ? List<dynamic>.from(savedPlaces!.map((x) => x))
            : [],
        "paymentMethods": paymentMethods != null
            ? List<dynamic>.from(paymentMethods!.map((x) => x))
            : [],
        "loginHistory": loginHistory != null
            ? List<dynamic>.from(loginHistory!.map((x) => x.toJson()))
            : [],
        "createdAt": createdAt,
        "__v": v,
      };
}

class CurrentLocation {
  final String? type;
  final List<double>? coordinates;

  CurrentLocation({
    this.type,
    this.coordinates,
  });

  factory CurrentLocation.fromJson(Map<String, dynamic> json) =>
      CurrentLocation(
        type: json["type"],
        coordinates: json["coordinates"] != null
            ? List<double>.from(json["coordinates"].map((x) => x.toDouble()))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates != null
            ? List<dynamic>.from(coordinates!.map((x) => x))
            : [],
      };
}

class Wallet {
  final int? balance;
  final List<dynamic>? transactions;

  Wallet({
    this.balance,
    this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        balance: json["balance"],
        transactions: json["transactions"] != null
            ? List<dynamic>.from(json["transactions"].map((x) => x))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "transactions": transactions != null
            ? List<dynamic>.from(transactions!.map((x) => x))
            : [],
      };
}

class NotificationSettings {
  final bool? pushNotifications;
  final bool? emailNotifications;
  final bool? smsNotifications;

  NotificationSettings({
    this.pushNotifications,
    this.emailNotifications,
    this.smsNotifications,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        pushNotifications: json["pushNotifications"],
        emailNotifications: json["emailNotifications"],
        smsNotifications: json["smsNotifications"],
      );

  Map<String, dynamic> toJson() => {
        "pushNotifications": pushNotifications,
        "emailNotifications": emailNotifications,
        "smsNotifications": smsNotifications,
      };
}

class LoginHistory {
  final String? device;
  final String? ipAddress;
  final String? id;
  final String? loginTime;

  LoginHistory({
    this.device,
    this.ipAddress,
    this.id,
    this.loginTime,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) => LoginHistory(
        device: json["device"],
        ipAddress: json["ipAddress"],
        id: json["_id"],
        loginTime: json["loginTime"],
      );

  Map<String, dynamic> toJson() => {
        "device": device,
        "ipAddress": ipAddress,
        "_id": id,
        "loginTime": loginTime,
      };
}
