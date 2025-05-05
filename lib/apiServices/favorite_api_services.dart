import 'package:dio/dio.dart';
import 'package:kota/model/news_model.dart';

class FavoritesApiService {
  final Dio _dio = Dio();

  Future<List<Datum>> fetchFavorites() async {
    try{
    final response = await _dio.get("https://kbaiota.org/api/news/get-all-news");

    if (response.statusCode == 200 && response.data['status'] == true) {
      final newsModel = NewsModel.fromJson(response.data);
      return newsModel.data; 
    } else {
      throw Exception("Failed to load news");
    }
    }catch(e){
      print(e);
      return [];
    }
  }

   Future<void> sendBookmarkStatusToApi(String id, bool status) async {
  try {
    FormData formData = FormData.fromMap({
      'news_id': id,
      'faverites': status.toString(), // sending as string "true"/"false"
    });

    final response = await _dio.post(
      'https://yourapi.com/update-bookmark',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          // 'Authorization': 'Bearer your_token', // If needed
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