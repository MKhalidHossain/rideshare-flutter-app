class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
