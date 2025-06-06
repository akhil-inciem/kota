import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:kota/views/base.dart';
import 'package:kota/views/drawer/executives_screen.dart';
import 'package:kota/views/favourites/widgets/favourite_list.dart';
import 'package:kota/views/forum/forum_detail_screen.dart';
import 'package:kota/views/forum/forum_screen.dart';
import 'package:kota/views/home/events_detail_screen.dart';
import 'package:kota/views/home/news_detail_screen.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

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

    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      Get.offAll(() => BaseScreen());
      await Future.delayed(const Duration(milliseconds: 100));

      final pathSegments = uri.pathSegments; // e.g., ['news', '5']

      if (pathSegments.isNotEmpty) {
        final section = pathSegments[0]; // 'news', 'events', etc.

        switch (section) {

          case 'forum':
          if (pathSegments.length > 1) {
              final threadId = pathSegments[1];
          Get.to(()=> ForumDetailScreen(threadId: threadId,));
          }
          break;

          case 'executive':
            Get.to(() => ExecutivePage());
            break;

          case 'news':
            if (pathSegments.length > 1) {
              final newsId = pathSegments[1];
              Get.to(() => NewsDetailScreen(newsId: newsId));
            }
            break;
          case 'events':
            if (pathSegments.length > 1) {
              final eventId = pathSegments[1];
              Get.to(() => EventsDetailScreen(eventId: eventId));
            }
            break;
          default:
            break;
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
      Get.offAll(() =>  BaseScreen());
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
