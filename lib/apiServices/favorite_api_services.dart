import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/favorite_model.dart';
import 'package:kota/model/news_model.dart';

class FavoritesApiService {
  final Dio _dio = Dio();

  Future<FavoritesModel> fetchFavorites() async {
  try {
    final response = await _dio.get(ApiEndpoints.favorites);

    if (response.statusCode == 200 && response.data['status'] == true) {
      return FavoritesModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load news and events");
    }
  } catch (e) {
    print("Error in fetchFavorites: $e");
    rethrow;
  }
}

   Future<void> sendNewsBookmarkStatusToApi(String id, bool status) async {
  try {
    FormData formData = FormData.fromMap({
      'news_id': id,
      'faverites': status.toString(),
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
  try {
    FormData formData = FormData.fromMap({
      'event_id': id,
      'faverites': status.toString(),
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