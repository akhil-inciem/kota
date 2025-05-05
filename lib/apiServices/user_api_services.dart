import 'package:dio/dio.dart';
import 'package:kota/model/profile_model.dart';

class UserApiService {
  final Dio _dio = Dio();

  Future<User> fetchUserProfile(String userId) async {
    try {
      final response = await _dio.get("http://192.168.48.119/kbiota/api/news/get-user?id=$userId"); 

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
