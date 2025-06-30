
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/forum_model.dart';
import 'package:kota/model/poll_model.dart';
import 'package:kota/model/poll_reaction_model.dart';

class PollApiService {
  static final dio.Dio _dio = dio.Dio();

  Future<List<PollData>> fetchAllPoll() async {
  final authController = Get.find<AuthController>();
  final String? userId = authController.userModel.value?.data.id;

  try {
    final response = await _dio.get(
      ApiEndpoints.getAllPoll,
      queryParameters: {
        if (userId != null) 'user_id': userId,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == true) {
      final List<dynamic> dataJson = response.data['data'];
      final List<PollData> pollList =
          dataJson.map((e) => PollData.fromJson(e)).toList();
      return pollList;
    } else {
      throw Exception("Failed to fetch reactions");
    }
  } catch (e) {
    print("Error in fetchreactions: $e");
    rethrow;
  }
}


  Future<List<ReactionData>> fetchPollReactions(String id) async {
    try {
      final response = await _dio.get(
        '${ApiEndpoints.pollReaction}/$id',
      );

      if (response.statusCode == 200 ) {
        final List<dynamic> dataJson = response.data['data'];
        final List<ReactionData> reactionDataList =
            dataJson.map((e) => ReactionData.fromJson(e)).toList();
        return reactionDataList;
      } else {
        throw Exception("Failed to fetch reactions");
      }
    } catch (e) {
      print("Error in fetchreactions: $e");
      rethrow;
    }
  }

  static Future<void> createPoll({
  required String title,
  required String description,
  required List<TextEditingController> pollFields,
  required String expiryDate,
  required bool allowMultiple,
}) async {
  final authController = Get.find<AuthController>();
  final String? userId = authController.userModel.value?.data.id;
  final String url = ApiEndpoints.createPoll;


  try {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('title', title),
      MapEntry('discription', "description"),
      MapEntry('created_by', userId ?? ''),
      MapEntry('expairydate',  expiryDate.split(' ').first),
      MapEntry('allowmultiple', allowMultiple == true ? '1' : '0'),
      MapEntry('is_guste', authController.isGuest ? '1' : '0'),
    ]);

    // Add each poll option as separate field entries
    for (var field in pollFields) {
      formData.fields.add(MapEntry('poll_feild[]', field.text));
    }

    final response = await _dio.post(url, data: formData);

    if (response.statusCode == 200 && response.data['status'] == true) {
      print("Poll created successfully");
    } else {
      throw Exception("Failed to create poll: ${response.data}");
    }
  } catch (e) {
    print(e);
    throw Exception("Create poll error: $e");
    
  }
}

static Future<void> editPoll({
  required String pollId,
  required String title,
  required String description,
  required List<TextEditingController> pollFields,
  required String expiryDate,
  required bool allowMultiple,
}) async {
  final authController = Get.find<AuthController>();
  final String? userId = authController.userModel.value?.data.id;
  final String url = ApiEndpoints.editPoll;


  try {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('poll_id', pollId),
      MapEntry('title', title),
      MapEntry('discription', "description"),
      MapEntry('created_by', userId ?? ''),
      MapEntry('expairydate', expiryDate.split(' ').first), // just yyyy-MM-dd
      MapEntry('allowmultiple', allowMultiple ? '1' : '0'),
      MapEntry('is_guste', authController.isGuest ? '1' : '0'),
    ]);

    for (var field in pollFields) {
      formData.fields.add(MapEntry('poll_feild[]', field.text));
    }

    final response = await _dio.post(url, data: formData);
    if (response.statusCode == 200 && response.data['status'] == true) {
      print("Poll created successfully");
    } else {
      throw Exception("Failed to create poll: ${response.data}");
    }
  } catch (e) {
    throw Exception("Create poll error: $e");
  }
}

 static Future<void> submitPollReaction({
    required String pollId,
    required String reaction,
  }) async {
    final authController = Get.find<AuthController>(); 
    final String? userId = authController.userModel.value?.data.id;

    final formData = FormData();

    // Add required fields
    formData.fields.addAll([
      MapEntry('user_id', userId ?? ''),
      MapEntry('poll_id', pollId),
      MapEntry('reaction[]', reaction),
      MapEntry('is_guste', authController.isGuest ? '1' : '0'),
    ]);

    try {
      final response = await _dio.post(ApiEndpoints.submitPoll, data: formData);
      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Poll reaction submitted successfully");
      } else {
        throw Exception("Failed to submit poll reaction: ${response.data}");
      }
    } catch (e) {
      throw Exception("Submit poll reaction error: $e");
    }
  }
}
