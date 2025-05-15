import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/membership_model.dart';
import 'package:kota/model/updates_model.dart';

import '../controller/auth_controller.dart';

class UpdateApiService {
  final Dio _dio = Dio();

  // ✅ 1. Get Membership Info by userId
  Future<MemberShipModel?> fetchMembership() async {
     final authController = Get.find<AuthController>();
      final userId = authController.userModel.value!.id;
    try {
      final response = await _dio.get('${ApiEndpoints.getMemberExpiry}$userId');
      if (response.statusCode == 200) {
        return MemberShipModel.fromJson(response.data);
      }
    } catch (e) {
      print('Error fetching membership: $e');
    }
    return null;
  }

  // ✅ 2. Get News & Events Updates
  Future<UpdatesModel?> fetchUpdates() async {
    try {
      final response = await _dio.get(ApiEndpoints.getUpdates);
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
