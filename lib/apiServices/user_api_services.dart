import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/profile_model.dart';
import '../controller/auth_controller.dart';


class UserApiService {
  final dio.Dio _dio = dio.Dio();
  final AuthController _authController = Get.find<AuthController>();

  Future<User> fetchUserProfile() async {
    try {
      final userId = _authController.userModel.value!.data.id;

      final response = await _dio.get(
        ApiEndpoints.getUserProfile,
        queryParameters: {
          'id': userId,
          'isguest': _authController.isGuest ? 1 : 0,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final userResponse = UserResponse.fromJson(response.data);
        return userResponse.user!;
      } else {
        throw Exception("Failed to load user profile");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to load user profile: $e");
    }
  }

  Future<void> updateProfile({
  required String firstName,
  required String lastName,
  required String primaryNumber,
  required String email,
  File? image,
}) async {
  final userModel = _authController.userModel.value;
  if (userModel == null) {
    throw Exception("User ID not available.");
  }

  final String url = ApiEndpoints.updateUserProfile;

  try {
    final formData = dio.FormData.fromMap({
      'user_id': userModel.data.id.toString(),
      'is_guest': _authController.isGuest ? '1' : '0',
      'first_name': firstName,
      'last_name': lastName,
      'primary_number': primaryNumber,
      'email': email,
      if (image != null)
        'photo': await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await _dio.post(
      url,
      data: formData,
      options: dio.Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      print("Profile updated successfully");
    } else {
      final errorMsg = response.data['message'] ?? 'Unknown error occurred';
      throw Exception("Failed to update profile: $errorMsg");
    }
  } catch (e) {
    throw Exception("Update profile error: $e");
  }
}


}


