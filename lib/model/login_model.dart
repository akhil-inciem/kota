class LoginResponseModel {
  final bool status;
  final String message;
  final String id;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.id,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
      id: json['id'].toString(),
    );
  }
}
