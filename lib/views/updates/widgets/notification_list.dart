import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/views/forum/discussions/forum_detail_screen.dart';
import 'package:kota/views/home/events_detail_screen.dart';
import 'package:kota/views/home/news_detail_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const NotificationTile({Key? key, required this.item}) : super(key: key);

  String timeAgo(DateTime createdTime) {
  final now = DateTime.now();
  final difference = now.difference(createdTime);

  if (difference.inDays > 10) {
    return DateFormat('dd MMM yyyy').format(createdTime);
  }

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  }
}
  

  String _htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text.trim() ?? '';
  }

  void _handleTap() {
  final type = item['type'];
  if (type == 'news' && item['news_id'] != null) {
    Get.to(() => NewsDetailScreen(newsId: item['news_id']));
  } else if (type == 'event' && item['event_id'] != null) {
    Get.to(() => EventsDetailScreen(eventId: item['event_id']));
  } else if (type == 'thread' && item['thread_id'] != null) {
    Get.to(() => ForumDetailScreen(threadId: item['thread_id']));
  } else if (type == 'poll_created') {
    final homeController = Get.find<HomeController>();
    final forumController = Get.find<ForumController>();
    forumController.selectedTabIndex.value = 1;
    homeController.index.value = 2;
  } else if ([
    'like_post',
    'comment_post',
    'reply_comment',
    'like_comment',
  ].contains(type) &&
      item['thread_id'] != null) {
    Get.to(() => ForumDetailScreen(threadId: item['thread_id']));
  }
}



Widget _buildLeadingIcon() {
  final type = item['type'];
  final photo = item['photo'];

  final rawName = item['name'] ?? 'User'; // Fallback if name is null

  final fallbackAvatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(rawName)}&background=0A58C9&color=ffffff';

  if ([
    'like_post',
    'comment_post',
    'reply_comment',
    'like_comment',
  ].contains(type)) {
    final imageUrl = (photo != null && photo.toString().isNotEmpty) ? photo : fallbackAvatarUrl;

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: 40,
          height: 40,
          placeholder: (context, url) =>
              const CircularProgressIndicator(strokeWidth: 1.5),
          errorWidget: (context, url, error) =>
              const Icon(Icons.person, size: 20),
        ),
      ),
    );
  }

  IconData iconData;
  switch (type) {
    case 'news':
      iconData = Icons.article_outlined;
      break;
    case 'event':
      iconData = Icons.event_outlined;
      break;
    case 'thread':
      iconData = Icons.forum_outlined;
      break;
    case 'poll_created':
      iconData = Icons.poll_outlined;
      break;
    default:
      iconData = Icons.notifications_active_outlined;
  }

  return CircleAvatar(
    radius: 20,
    backgroundColor: Colors.grey.shade200,
    child: Icon(iconData, color: Colors.black54),
  );
}


  @override
  Widget build(BuildContext context) {
    final DateTime? date = item['date'];

    String description = '';
    if (item['message'] != null) {
      description = item['message'];
    } else if (item['description'] != null) {
      description = _htmlToPlainText(item['description']);
    } else if (item['content'] != null) {
      description = _htmlToPlainText(item['content']);
    }

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeadingIcon(),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (date != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3D8FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            timeAgo(date),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF2640C8),
                            ),
                          ),
                        ),
                      if (item['actionText'] != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDD3D3D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item['actionText'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
