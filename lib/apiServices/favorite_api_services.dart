import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:kota/constants/api.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/favorite_model.dart';
import 'package:kota/model/news_model.dart';

class FavoritesApiService {
  final Dio _dio = Dio();

  Future<FavoritesModel> fetchFavorites() async {
    final authController = getx.Get.find<AuthController>();
      final userId = authController.userModel.value!.data.id;
  try {
    final response = await _dio.get(
      ApiEndpoints.favorites,
      queryParameters: {
        'user_id': userId,
      },
    );

    if (response.statusCode == 200) {
      final responseString = response.data.toString().trim();
      final jsonString = jsonDecode(responseString);
      print(jsonString['status']);
      return FavoritesModel.fromJson(jsonString);
    } else {
      throw Exception("Failed to load favorites");
    }
  } catch (e, st) {
    print("Error in fetchFavorites: $e");
    print(st);
    rethrow;
  }
}

   Future<void> sendNewsBookmarkStatusToApi(String id, bool status) async {
    final authController = getx.Get.find<AuthController>();
      final userId = authController.userModel.value!.data.id;
  try {
    FormData formData = FormData.fromMap({
      'user_id': userId,
      'news_id': id,
      'user_type' : authController.isGuest ? 1 : 0,
      'badges' : 'news'
    });

    final response = await _dio.post(
      ApiEndpoints.updateNewsFavorites,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    if (response.statusCode == 200) {
      print('Bookmark status updated successfully');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending bookmark status: $e');
    rethrow;
  }
}
Future<void> sendEventsBookmarkStatusToApi(String id, bool status) async {
  final authController = getx.Get.find<AuthController>();
      final userId = authController.userModel.value!.data.id;
  try {
    FormData formData = FormData.fromMap({
      'user_id': userId,
      'event_id': id,
      'user_type' : authController.isGuest ? 1 : 0,
      'badges' : 'events'
    });

    final response = await _dio.post(
      ApiEndpoints.updateEventFavorites,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (response.statusCode == 200) {
      print('Bookmark status updated successfully');
    } else {
      print('Failed to update: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending bookmark status: $e');
    rethrow;
  }
}
}