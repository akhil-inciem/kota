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
    final userId = _authController.userModel.value!.data.id;

    final String url = ApiEndpoints.updateUserProfile;

    final Map<String, dynamic> data = {
      'user_id': userId,
      'is_guest':_authController.isGuest ? 1 : 0,
      'first_name': firstName,
      'last_name': lastName,
      'primary_number': primaryNumber,
      'email': email,
    };

    if (image != null) {
      data['photo'] = await dio.MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      );
    }

    final formData = dio.FormData.fromMap(data);

    try {
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Profile updated successfully");
      } else {
        throw Exception("Failed to update profile: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Update profile error: $e");
    }
  }
}


