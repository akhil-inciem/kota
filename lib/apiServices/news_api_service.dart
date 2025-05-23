import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/news_model.dart';

import '../controller/auth_controller.dart';

class NewsApiService {
  final Dio _dio = Dio();
  static final _authController = Get.find<AuthController>();
  static final String? userId = _authController.userModel.value?.data.id;
  
  Future<List<NewsDatum>> fetchNews() async {
    try {
      final response = await _dio.get(ApiEndpoints.getNews);

      if (response.statusCode == 200 && response.data['status'] == true) {
        final newsModel = NewsModel.fromJson(response.data);
        return newsModel.data;
      } else {
        throw Exception("Failed to load news");
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<NewsDatum?> fetchNewsById({
  required String newsId,
}) async {
  try {
    final response = await _dio.get(
      ApiEndpoints.getNewsById,
      queryParameters: {
        'user_id': userId,
        'news_id': newsId,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      return NewsDatum.fromJson(response.data['data'][0]);
    } else {
      throw Exception("Failed to load news item");
    }
  } catch (e) {
    print("Error fetching news by ID: $e");
    return null;
  }
}

}
