import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:kota/views/base.dart';
import 'package:kota/views/drawer/executives_screen.dart';
import 'package:kota/views/favourites/widgets/favourite_list.dart';
import 'package:kota/views/forum/discussions/forum_detail_screen.dart';
import 'package:kota/views/forum/discussions/forum_screen.dart';
import 'package:kota/views/home/events_detail_screen.dart';
import 'package:kota/views/home/news_detail_screen.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialNavigationScreen extends StatefulWidget {
  const InitialNavigationScreen({super.key});

  @override
  State<InitialNavigationScreen> createState() =>
      _InitialNavigationScreenState();
}

class _InitialNavigationScreenState extends State<InitialNavigationScreen> {
  final AppLinks _appLinks = AppLinks();

  bool _navigating = false;
  bool _initialLinkHandled = false;

  @override
  void initState() {
    super.initState();
    _handleInitialLink();
    _handleDeepLinkStream();
    _navigateAfterDelay();
  }

  /// Handle cold start deep link
  Future<void> _handleInitialLink() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _initialLinkHandled = true;
      await _handleUri(initialUri);
    }
  }

  /// Handle deep links while app is running
  void _handleDeepLinkStream() {
    _appLinks.uriLinkStream.listen((uri) async {
      if (!_navigating && uri != null) {
        await _handleUri(uri);
      }
    });
  }

  /// Actual navigation based on URI and login status
  Future<void> _handleUri(Uri uri) async {
  _navigating = true;

  final urlString = uri.toString();

  if (urlString.contains('index/memberSignUp')) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    _navigating = false;
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  if (isLoggedIn) {
    Get.offAll(() => BaseScreen());
    await Future.delayed(const Duration(milliseconds: 100));

    final path = uri.path.toLowerCase();
    final queryParams = uri.queryParameters;

    switch (path) {
      case '/index/newsdetails':
        final newsId = queryParams['newsId'];
        if (newsId != null) {
          Get.to(() => NewsDetailScreen(newsId: newsId));
        }
        break;

      case '/index/eventdetails':
        final eventId = queryParams['eventId'];
        if (eventId != null) {
          Get.to(() => EventsDetailScreen(eventId: eventId));
        }
        break;
    }

    final oldStylePath = uri.query; // gets `forum/123`
    if (oldStylePath.isNotEmpty) {
      final parts = oldStylePath.split('/');
      if (parts.length == 2 && parts[0] == 'forum') {
        final forumId = parts[1];
        Get.to(() => ForumDetailScreen(threadId: forumId));
      }
    }

  } else {
    Get.offAll(() => const LoginScreen());
  }

  _navigating = false;
}


  /// If no initial deep link, navigate after delay
  Future<void> _navigateAfterDelay() async {
    if (_initialLinkHandled || _navigating) return;

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      Get.offAll(() => BaseScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF015FC9), Color(0xFF7001C5)],
          ),
        ),
      ),
    );
  }
}
