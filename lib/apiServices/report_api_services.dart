import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';

class ReportApiServices{
  final Dio _dio = Dio();

  Future<bool> blockUser({
    required String userId,
    required String userType,
    required String blockedUserId,
    required String blockedUserType,
  }) async {
    try {
      final formData = FormData.fromMap({
        'blocker_id': userId,
        'blocker_type': userType,
        'blocked_id': blockedUserId,
        'blocked_type': blockedUserType,
      });

      final response = await _dio.post(
        ApiEndpoints.blockUser,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      if (response.statusCode == 200) {
        print("Block successful: ${response.data}");
        return true;
      } else {
        print("Block failed: ${response.statusCode} - ${response.data}");
        return false;
      }
    } catch (e) {
      print("Block API error: $e");
      return false;
    }
  }

  Future<void> flagUser({
  required String blockedUserId,
  required String blockedUsertype,
  required String userId,
  required String userType,
  String pollId = '',
  String threadId = '',
  String commentId = '',
  String replyId = '',
  required String reason,
  String additionalDetails = '',
}) async {
  try {
    final Map<String, dynamic> formMap = {
      'flagged_id': blockedUserId,
      'flagged_type': blockedUsertype,
      'flagger_id': userId,
      'flagger_type': userType,
      'reason': reason,
    };

    if (threadId.isNotEmpty) {
      formMap['content_type'] = 'thread';
      formMap['content_id'] = threadId;
    } else if (commentId.isNotEmpty) {
      formMap['content_type'] = 'comment';
      formMap['content_id'] = commentId;
    } else if (replyId.isNotEmpty) {
      formMap['content_type'] = 'reply';
      formMap['content_id'] = replyId;
    } else if (pollId.isNotEmpty) {
      formMap['content_type'] = 'poll';
      formMap['content_id'] = pollId;
    }

    if (additionalDetails.isNotEmpty) {
      formMap['additional_details'] = additionalDetails;
    }

    final formData = FormData.fromMap(formMap);

    final response = await _dio.post(
      ApiEndpoints.flagUser,
      data: formData,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      print('Flag submitted successfully');
    } else {
      print('Flag failed: ${response.statusMessage}');
    }
  } catch (e) {
    print('Error flagging user: $e');
  }
}
}
