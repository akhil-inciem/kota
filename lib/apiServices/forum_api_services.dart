import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/forum_model.dart';
import 'package:dio/dio.dart' as dio;

class ForumApiService {
  static final dio.Dio _dio = dio.Dio();

  Future<List<ForumData>> fetchThreads() async {
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

  Future<ForumData> fetchSingleThread(String threadId) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    try {
      final response = await _dio.get(
        '${ApiEndpoints.getThreadDetails}/$threadId',
        queryParameters: {
          authController.isGuest ? 'guest_user_id' : 'user_id': userId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final dynamic dataJson = response.data['data'];
        final ForumData forumData = ForumData.fromJson(dataJson);
        return forumData;
      } else {
        throw Exception("Failed to load forum thread");
      }
    } catch (e) {
      print("Error in fetchSingleThread: $e");
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

  static Future<void> likeThread(String threadId) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    final String url = '${ApiEndpoints.likeThread}$threadId';

    try {
      final response = await _dio.post(
        url,
        data: dio.FormData.fromMap({
          authController.isGuest ? 'guest_user_id' : 'user_id': userId,
        }),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Thread liked successfully");
      } else {
        throw Exception("Failed to like Thread: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Like Thread error: $e");
    }
  }

  static Future<void> postComment({
    required String threadId,
    required String comment,
  }) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    final String url = '${ApiEndpoints.createComment}$threadId';

    try {
      final response = await _dio.post(
        url,
        data: dio.FormData.fromMap({
          authController.isGuest ? 'guest_user_id' : 'user_id': userId,
          'content': comment,
        }),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Comment posted successfully");
      } else {
        throw Exception("Failed to post comment: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Post comment error: $e");
    }
  }

  Future<void> likeComment(String commentId) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    final String url = '${ApiEndpoints.likeComment}$commentId';

    try {
      final response = await _dio.post(
        url,
        data: dio.FormData.fromMap({
          authController.isGuest ? 'guest_user_id' : 'user_id': userId,
        }),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Comment liked successfully");
      } else {
        throw Exception("Failed to like comment: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Like comment error: $e");
    }
  }

  static Future<void> postReply({
    required String commentId,
    required String reply,
    required String threadId,
  }) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    final String url = '${ApiEndpoints.createCommentReply}$threadId';

    try {
      final dio.FormData formData = dio.FormData.fromMap({
        authController.isGuest ? 'guest_user_id' : 'user_id': userId,
        'content': reply,
        'comment_id': commentId,
      });

      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Reply posted successfully");
      } else {
        throw Exception("Failed to post reply: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Post reply error: $e");
    }
  }

  Future<void> likeReply(String replyId) async {
     final authController = Get.find<AuthController>();
    final String? userId = authController.userModel.value?.data.id;
    final String url = '${ApiEndpoints.likeReply}$replyId';

    try {
      final dio.FormData formData = dio.FormData.fromMap({
        authController.isGuest ? 'guest_user_id' : 'user_id': userId,
      });

      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200 && response.data['status'] == true) {
        print("Reply liked successfully");
      } else {
        throw Exception("Failed to like reply: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Like reply error: $e");
    }
  }
}
