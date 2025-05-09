import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/news_model.dart';

class NewsApiService {
  final Dio _dio = Dio();

  Future<List<NewsDatum>> fetchNews() async {
    try{
    final response = await _dio.get(ApiEndpoints.getNews);

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