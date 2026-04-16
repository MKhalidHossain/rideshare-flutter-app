class NotificationResponseModel {
  final bool? success;
  final NotificationData? data;

  NotificationResponseModel({this.success, this.data});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      success: json['success'],
      data:
          json['data'] != null ? NotificationData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class NotificationData {
  final List<AppNotification> notifications;
  final Pagination? pagination;

  NotificationData({
    this.notifications = const [],
    this.pagination,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) => AppNotification.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class AppNotification {
  final String? id;
  final UserRef? senderId;
  final UserRef? receiverId;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? createdAt;
  final int? v;

  AppNotification({
    this.id,
    this.senderId,
    this.receiverId,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.v,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'],
      senderId:
          json['senderId'] != null ? UserRef.fromJson(json['senderId']) : null,
      receiverId: json['receiverId'] != null
          ? UserRef.fromJson(json['receiverId'])
          : null,
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId?.toJson(),
      'receiverId': receiverId?.toJson(),
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt,
      '__v': v,
    };
  }
}

class UserRef {
  final String? id;
  final String? fullName;
  final String? profileImage;

  UserRef({
    this.id,
    this.fullName,
    this.profileImage,
  });

  factory UserRef.fromJson(Map<String, dynamic> json) {
    return UserRef(
      id: json['_id'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'profileImage': profileImage,
    };
  }
}

class Pagination {
  final int? current;
  final int? pages;
  final int? total;

  Pagination({this.current, this.pages, this.total});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      current: json['current'],
      pages: json['pages'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'pages': pages,
      'total': total,
    };
  }
}
