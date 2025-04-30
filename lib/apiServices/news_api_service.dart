import 'package:dio/dio.dart';
import 'package:kota/model/news_model.dart';

class NewsApiService {
  final Dio _dio = Dio();

  Future<List<Datum>> fetchNews() async {
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
}