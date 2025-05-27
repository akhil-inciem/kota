import 'package:get/get.dart';
import 'package:app_links/app_links.dart';

import '../views/home/events_detail_screen.dart';
import '../views/home/news_detail_screen.dart';

void setupAppLinks() {
  final appLinks = AppLinks();

  appLinks.uriLinkStream.listen((Uri uri) {
    _handleIncomingLink(uri);
  });

  appLinks.getInitialLink().then((uri) {
    if (uri != null) _handleIncomingLink(uri);
  });
}

void _handleIncomingLink(Uri uri) {
  final pathSegments = uri.pathSegments;

  if (pathSegments.isNotEmpty) {
    final type = pathSegments[0];
    final id = pathSegments.length > 1 ? pathSegments[1] : null;

    if (type == 'news' && id != null) {
      Get.to(() => NewsDetailScreen(newsId: id));
    } else if (type == 'event' && id != null) {
      Get.to(() => EventsDetailScreen(eventId: id));
    }
  }
}
