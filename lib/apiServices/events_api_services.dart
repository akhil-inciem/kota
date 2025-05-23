import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/event_model.dart';

class EventsApiService {
  final Dio _dio = Dio();
  static final _authController = Get.find<AuthController>();
  static final String? userId = _authController.userModel.value?.data.id;
  
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

  Future<EventsDatum?> fetchEventsById({
  required String eventsId,
}) async {
  try {
    final response = await _dio.get(
      ApiEndpoints.getEventById,
      queryParameters: {
        'user_id': userId,
        'events_id': eventsId,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      return EventsDatum.fromJson(response.data['data'][0]);
    } else {
      throw Exception("Failed to load news item");
    }
  } catch (e) {
    print("Error fetching news by ID: $e");
    return null;
  }
}

}