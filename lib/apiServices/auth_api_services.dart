import 'package:dio/dio.dart';
import 'package:kota/model/login_model.dart';

class AuthApiService {
  final Dio _dio = Dio();

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://192.168.48.119/kbiota/api/news/login',
        data: {
          'email': email,
          'member_password': password,
        },
        options: Options(
        contentType: Headers.formUrlEncodedContentType, // Sets content type to x-www-form-urlencoded
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
}
