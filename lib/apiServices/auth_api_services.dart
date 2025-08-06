import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/guest_model.dart';
import 'package:kota/model/login_model.dart';

import '../controller/auth_controller.dart';

class AuthApiService {
  final Dio _dio = Dio();

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final formData = FormData.fromMap({
        'mail_id': email,
        'member_password': password,
      });

      final response = await _dio.post(ApiEndpoints.login, data: formData);

      if (response.statusCode == 200) {
        print(response.data);
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      print('Login error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> eulaPost() async {
    final authController = Get.find<AuthController>();
    final userId = authController.userModel.value!.data.id;
    try {
      FormData formData = FormData.fromMap({
        'user_id': userId,
        'user_type': authController.isGuest ? 'guest' : 'member',
      });

      final response = await _dio.post(ApiEndpoints.eula, data: formData);

      if (response.statusCode == 200) {
      } else {
        throw Exception('Agreement failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Agreement failed: $e');
    }
  }

  Future<void> resetPasswordUser(String email) async {
    try {
      FormData formData = FormData.fromMap({'emailid': email});

      final response = await _dio.post(
        ApiEndpoints.resetPassword,
        data: formData,
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Mail failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Mail failed: $e');
    }
  }

  Future<Map<String, dynamic>> forgotPasswordGuest(String email) async {
    try {
      FormData formData = FormData.fromMap({'email': email});

      final response = await _dio.post(
        ApiEndpoints.forgotPasswordGuest,
        data: formData,
      );

      if (response.statusCode == 200) {
        print(response);
        return response.data as Map<String, dynamic>; // Ensure proper type
      } else {
        throw Exception('Mail failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Mail failed: $e');
    }
  }

  Future<bool> verifyGuestOtp(String guestId, String otp) async {
    try {
      FormData formData = FormData.fromMap({'user_id': guestId, 'otp': otp});

      final response = await _dio.post(
        ApiEndpoints.verifyGuestOtp,
        data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('OTP verification failed: $e');
      return false;
    }
  }

  Future<bool> forgotupdateGuestPassword({
    required String guestId,
    required String password,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'user_id': guestId,
        'newpassword': password,
      });

      final response = await _dio.post(
        ApiEndpoints.forgotupdateGuestPassword,
        data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return true;
      } else {
        throw Exception('Reset failed: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Reset error: $e');
    }
  }

  Future<String> resetGuestPassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'mail_id': email,
        'previous_password': oldPassword,
        'new_password': newPassword,
      });

      final response = await _dio.post(
        ApiEndpoints.resetGuestPassword,
        data: formData,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.data);
        if (decoded['status'] == true) {
          return decoded['message'] ?? "Password reset successfully.";
        } else {
          return decoded['message'] ?? "Password reset failed.";
        }
      } else {
        return "Server returned status code: ${response.statusCode}";
      }
    } catch (e) {
      print("Error in resetGuestPassword: $e");
      return "Exception occurred: $e";
    }
  }

  Future<GuestModel> register({
    required String fullName,
    required String mailId,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {
          'full_name': fullName,
          'mail_id': mailId,
          'member_password': password,
          'confirm_member_password': confirmPassword,
          'phone_number': phoneNumber,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.statusCode == 200) {
        return GuestModel.fromJson(response.data);
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> deleteAccount() async {
    final authController = getx.Get.find<AuthController>();
    final userId = authController.userModel.value!.data.id;
    try {
      FormData formData = FormData.fromMap({
        'user_id': userId,
        'user_type': authController.isGuest ? "guest" : "member",
      });

      final response = await _dio.post(
        ApiEndpoints.deleteUser,
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (_) => true,
        ),
      );
      print(response);
      print(response.data);
    } catch (e) {
      if (e is DioException) {
      } else {}
    }
  }

  Future<void> logout() async {
    final authController = getx.Get.find<AuthController>();
    final userId = authController.userModel.value!.data.id;
    try {
      FormData formData = FormData.fromMap({
        'user_id': userId,
        'isguest': authController.isGuest ? 1 : 0,
      });

      final response = await _dio.post(
        ApiEndpoints.logout,
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          validateStatus: (_) => true, // prevent crash on unexpected status
        ),
      );
    } catch (e) {
      if (e is DioException) {
      } else {}
    }
  }
}
