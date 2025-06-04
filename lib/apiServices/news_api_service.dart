import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/advertisement_model.dart';
import 'package:kota/model/news_model.dart';

import '../controller/auth_controller.dart';

class NewsApiService {
  final Dio _dio = Dio();
  
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
   final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
  try {
    final response = await _dio.get(
      ApiEndpoints.getNewsById,
      queryParameters: {
        'user_id': userId,
        'news_id': newsId,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      final responseString = response.data.toString().trim();
      final jsonString = jsonDecode(responseString);
      return NewsDatum.fromJson(jsonString['data'][0]);
    } else {
      throw Exception("Failed to load news item");
    }
  } catch (e) {
    print("Error fetching news by ID: $e");
    return null;
  }
}

Future<AdvertisementModel?> fetchAdvertisement() async {
  try {
    final response = await _dio.get(ApiEndpoints.advertisement);

    if (response.statusCode == 200) {
      final responseString = response.data.toString().trim();
      final jsonString = jsonDecode(responseString);
      return AdvertisementModel.fromJson(jsonString);
    } else {
      throw Exception("Failed to load advertisements");
    }
  } catch (e,st) {
    print("Error fetching advertisements: $e");
    print('=====$st');
    return null;
  }
}

}
