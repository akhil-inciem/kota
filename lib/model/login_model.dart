class LoginResponseModel {
  final bool status;
  final String message;
  final String role;
  final UserData data;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.role,
    required this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      role: json['role'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
    );
  }
}
class UserData {
  final String id;
  final bool isGuest;

  UserData({
    required this.id,
    required this.isGuest,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'].toString(),
      isGuest: json['isguest'] ?? false,
    );
  }
}

