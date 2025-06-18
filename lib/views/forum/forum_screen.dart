// forum_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/forum_tab.dart';
import 'package:kota/views/forum/poll_tab.dart';
import 'package:kota/views/forum/widgets/forum_tab_bar.dart';
import 'package:kota/views/home/widgets/home_tab_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        SizedBox(height: 0.5.h),
        CustomSearchBar(
          controller: forumController.searchController,
          onChanged: (value) => forumController.setSearchQuery(value),
        ),
        SizedBox(height: 1.h),
        ForumTabBar(
          selectedIndex: forumController.selectedTabIndex.value,
          onTabSelected: (index) => setState(() => forumController.selectedTabIndex.value = index),
        ),
        Expanded(
          child: forumController.selectedTabIndex.value == 0
              ? const ForumDiscussionTab()
              : const ForumPollTab(),
        ),
      ],
    );
  }
}