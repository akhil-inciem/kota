// forum_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/discussions/forum_tab.dart';
import 'package:kota/views/forum/polls/poll_tab.dart';
import 'package:kota/views/forum/discussions/widgets/forum_tab_bar.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ForumController forumController = Get.put(ForumController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final isGuest = authController.isGuest;

    return Column(
      children: [
        TopBar(),
        SizedBox(height: 0.5.h),
        CustomSearchBar(
          controller: forumController.searchController,
          onChanged: (value) => forumController.setSearchQuery(value),
        ),
        SizedBox(height: 1.h),

        // If not guest, show tabs
        if (!isGuest)
          ForumTabBar(
            selectedIndex: forumController.selectedTabIndex.value,
            onTabSelected: (index) =>
                setState(() => forumController.selectedTabIndex.value = index),
          ),

        // Content
        Expanded(
          child: isGuest
              ? const ForumDiscussionTab() // Always show discussion tab for guest
              : Obx(() {
                  return forumController.selectedTabIndex.value == 0
                      ? const ForumDiscussionTab()
                      : const ForumPollTab();
                }),
        ),
      ],
    );
  }
}
