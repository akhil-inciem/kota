import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/forum_model.dart';
import 'package:dio/dio.dart' as dio;

class ForumApiService {
  static final dio.Dio _dio = dio.Dio();

  Future<List<ForumData>> fetchPolls() async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    try {
      final response = await _dio.get(
        ApiEndpoints.getAllThreads,
        queryParameters: {
          authController.isGuest ? 'guest_user_id' : 'user_id': userId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final List<dynamic> dataJson = response.data['data'];
        final List<ForumData> forumDataList =
            dataJson.map((e) => ForumData.fromJson(e)).toList();
        return forumDataList;
      } else {
        throw Exception("Failed to load forum threads");
      }
    } catch (e) {
      print("Error in fetchThreads: $e");
      rethrow;
    }
  }

  static Future<void> postDiscussion({
    required String title,
    required String description,
    required List<XFile> images,
  }) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    if (userId == null) {
      throw Exception("User ID not found. Make sure user is logged in.");
    }

    final String url = ApiEndpoints.createThread;

    final dio.FormData formData = dio.FormData.fromMap({
      'title': title,
      authController.isGuest ? 'guest_user_id' : 'user_id': userId,
      'content': description,
      'images[]': await Future.wait(
        images.map(
          (image) async => await dio.MultipartFile.fromFile(
            image.path,
            filename: image.name,
          ),
        ),
      ),
    });

    try {
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Discussion posted successfully");
      } else {
        throw Exception("Failed to post discussion: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Post discussion error: $e");
    }
  }

}
