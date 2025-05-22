import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/profile_model.dart';

import '../controller/auth_controller.dart';

class UserApiService {
  final Dio _dio = Dio();

  Future<User> fetchUserProfile() async {
    try {
      final authController = Get.find<AuthController>();
      final userId = authController.userModel.value!.data.id;

      final response = await _dio.get(ApiEndpoints.getUserProfile, queryParameters: {
        'id': userId,
        'isguest': authController.isGuest ? 1 : 0
      },);

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
}

