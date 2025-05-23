import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/guest_model.dart';
import 'package:kota/model/login_model.dart';

class AuthApiService {
  final Dio _dio = Dio();

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': 
          // email,
          'athiathi125@gmail.com',
          'member_password': 
          // password,
          'Devu@2000'
        },
        options: Options(
          contentType:
              Headers
                  .formUrlEncodedContentType, // Sets content type to x-www-form-urlencoded
        ),
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
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
}
