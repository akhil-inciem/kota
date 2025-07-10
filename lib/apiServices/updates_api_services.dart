import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/membership_model.dart';
import 'package:kota/model/updates_model.dart';

import '../controller/auth_controller.dart';

class UpdateApiService {
  final Dio _dio = Dio();

  Future<MemberShipModel?> fetchMembership() async {
     final authController = Get.find<AuthController>();
      final userId = authController.userModel.value!.data.id;
    try {
      final response = await _dio.get(ApiEndpoints.getMemberExpiry,queryParameters: {
        'member': userId,
      },);
      if (response.statusCode == 200) {
        final responseString = response.data.toString().trim();
      final jsonString = jsonDecode(responseString);
      print(jsonString);
        return MemberShipModel. fromJson(jsonString);
      }
    } catch (e) {
      print('Error fetching membership: $e');
    }
    return null;
  }
  
  Future<UpdatesModel?> fetchUpdates() async {
  final authController = Get.find<AuthController>();
  final userId = authController.userModel.value!.data.id;

  try {
    final response = await _dio.get(
      ApiEndpoints.getUpdates,
      queryParameters: {
        'user_id': userId,
        'is_guest':authController.isGuest ? '1' : '0'
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.data);
      return UpdatesModel.fromJson(decoded);
    }
  } catch (e) {
    print('Error fetching updates: $e');
  }

  return null;
}

}
