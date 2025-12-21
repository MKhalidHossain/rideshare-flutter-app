class GetProfileResponseModel {
  final bool? success;
  final ProfileData? data;

  GetProfileResponseModel({this.success, this.data});

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetProfileResponseModel(
      success: json['success'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class ProfileData {
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

  ProfileData({
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

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      notificationSettings: json['notificationSettings'] != null
          ? NotificationSettings.fromJson(json['notificationSettings'])
          : null,
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      profileImage: json['profileImage'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      refreshToken: json['refreshToken'],
      isActive: json['isActive'],
      savedPlaces: json['savedPlaces'] ?? [],
      paymentMethods: json['paymentMethods'] ?? [],
      loginHistory: (json['loginHistory'] as List<dynamic>?)
          ?.map((e) => LoginHistory.fromJson(e))
          .toList(),
      createdAt: json['createdAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLocation': currentLocation?.toJson(),
      'wallet': wallet?.toJson(),
      'notificationSettings': notificationSettings?.toJson(),
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'profileImage': profileImage,
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'refreshToken': refreshToken,
      'isActive': isActive,
      'savedPlaces': savedPlaces,
      'paymentMethods': paymentMethods,
      'loginHistory': loginHistory?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      '__v': v,
    };
  }
}

class CurrentLocation {
  final String? type;
  final List<double>? coordinates;

  CurrentLocation({this.type, this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'],
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}

class Wallet {
  final double? balance;
  final List<dynamic>? transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] ?? 0).toDouble(),
      transactions: json['transactions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'transactions': transactions,
    };
  }
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

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushNotifications: json['pushNotifications'],
      emailNotifications: json['emailNotifications'],
      smsNotifications: json['smsNotifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNotifications': pushNotifications,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
    };
  }
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

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      device: json['device'],
      ipAddress: json['ipAddress'],
      id: json['_id'],
      loginTime: json['loginTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device': device,
      'ipAddress': ipAddress,
      '_id': id,
      'loginTime': loginTime,
    };
  }
}
