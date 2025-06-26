import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/views/events/all_events_tab.dart' show AllEventsTab;
import 'package:kota/views/events/event_calendar_tab.dart';
import 'package:kota/views/events/widgets/custom_calendar.dart';
import 'package:kota/views/events/widgets/event_tab_bar.dart';
import 'package:kota/views/events/widgets/today_event_card.dart';
import 'package:kota/views/events/widgets/upcoming_event_card.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../widgets/search_bar.dart';

class EventScreen extends StatelessWidget {
  EventScreen({Key? key}) : super(key: key);

  final EventController controller = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Column(
  children: [
    TopBar(isEvent: true),
    SizedBox(height: 1.h),

    // Show search bar only for All Events tab
    Obx(() {
      if (controller.selectedTabIndex.value == 0) {
        return Column(
          children: [
            CustomSearchBar(controller: controller.searchController),
            SizedBox(height: 1.h),
          ],
        );
      } else {
        // Clear search text when switching tabs
        if (controller.searchController.text.isNotEmpty) {
          controller.searchController.clear();
        }
        return const SizedBox.shrink();
      }
    }),

    // Custom Tab Bar
    Obx(() => EventTabBar(
          selectedIndex: controller.selectedTabIndex.value,
          onTabSelected: (index) {
            controller.selectedTabIndex.value = index;
          },
        )),

    SizedBox(height: 1.h),

    // Tab Views
    Expanded(
      child: Obx(() {
        switch (controller.selectedTabIndex.value) {
          case 0:
            return AllEventsTab(); 
          case 1:
            return EventCalendarTab(); 
          default:
            return const SizedBox.shrink();
        }
      }),
    ),
  ],
),

    );
  }
}
