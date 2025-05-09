import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/event_model.dart';

class EventsApiService {
  final Dio _dio = Dio();

  Future<List<EventsDatum>> fetchEvents() async {
    try{
    final response = await _dio.get(ApiEndpoints.getEvents);

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

  Future<List<EventsDatum>> postFavEvents() async {
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