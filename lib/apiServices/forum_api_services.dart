import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ForumApiService {
  static final Dio _dio = Dio();

  static Future<void> postDiscussion({
    required String title,
    required String description,
    required List<XFile> images,
  }) async {
    final String url = "https://your-api-url.com/discussions";

    FormData formData = FormData.fromMap({
      'title': title,
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
