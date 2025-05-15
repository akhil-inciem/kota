import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/forum_model.dart';

class ForumApiService {
  static final Dio _dio = Dio();

  Future<List<ForumData>> fetchThreads() async {
  try {
    final response = await _dio.get(ApiEndpoints.getAllThreads);

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

// Future<ForumData> fetchSingleThread(String userId) async {
//   try {
//     final response = await _dio.get('${ApiEndpoints.getThreadDetails}/$userId');

//     if (response.statusCode == 200 && response.data['status'] == true) {
//       final List<dynamic> dataJson = response.data['data'];
//       final List<ForumData> forumDataList =
//           dataJson.map((e) => ForumData.fromJson(e)).toList();
//       return forumDataList;
//     } else {
//       throw Exception("Failed to load forum threads");
//     }
//   } catch (e) {
//     print("Error in fetchThreads: $e");
//     rethrow;
//   }
// }

  static Future<void> postDiscussion({
    required String title,
    required String description,
    required List<XFile> images,
  }) async {
    final String url = ApiEndpoints.createThread;

    FormData formData = FormData.fromMap({
      'title': title,
      'id':56,
      'content': description,
      'images': await Future.wait(images.map(
        (image) async => await MultipartFile.fromFile(
          image.path,
          filename: image.name,
        ),
      )),
    });

    try {
      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        print("Discussion posted successfully");
      } else {
        throw Exception("Failed to post discussion: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Post discussion error: $e");
    }
  }
}
