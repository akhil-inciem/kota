import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/executive_model.dart';
import 'package:kota/model/profile_model.dart';
import 'package:kota/model/vision_mission_model.dart';

class DrawerApiServices {
  final Dio _dio = Dio();

  Future<List<LeadersDetail>> fetchExecutives() async {
    try {
      final response = await _dio.get(ApiEndpoints.getMembers); 

      if (response.statusCode == 200 ) {
        final decoded = jsonDecode(response.data);
      final executiveModel = ExecutiveModel.fromJson(decoded);
      return executiveModel.data!.leadersDetails; 
    } else {
      throw Exception("Failed to load news");
    }
    } catch (e) {
      print(e);
      throw Exception("Failed to load user profile: $e");
    }
  }

  Future<List<VisionDatum>> fetchVisionAndMission() async {
    try {
      final response = await _dio.get(ApiEndpoints.getVisionMission); 

      if (response.statusCode == 200 ) {
      final executiveModel = VisionModel.fromJson(response.data);
      return executiveModel.data; 
    } else {
      throw Exception("Failed to load news");
    }
    } catch (e) {
      print(e);
      throw Exception("Failed to load user profile: $e");
    }
  }
}
