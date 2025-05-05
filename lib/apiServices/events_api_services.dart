import 'package:dio/dio.dart';
import 'package:kota/model/event_model.dart';

class EventsApiService {
  final Dio _dio = Dio();

  Future<List<Datum>> fetchEvents() async {
    try{
    final response = await _dio.get("https://kbaiota.org/api/news/get-all-events");

    if (response.statusCode == 200 && response.data['status'] == true) {
      final eventsModel = EventsModel.fromJson(response.data);
      return eventsModel.data; 
    } else {
      throw Exception("Failed to load events");
    }
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<List<Datum>> postFavEvents() async {
    try{
    final response = await _dio.post("https://kbaiota.org/kbiota/api/news/updatevent-badges-favorites");

    if (response.statusCode == 200 && response.data['status'] == true) {
      final eventsModel = EventsModel.fromJson(response.data);
      return eventsModel.data; 
    } else {
      throw Exception("Failed to load events");
    }
    }catch(e){
      print(e);
      return [];
    }
  }
}