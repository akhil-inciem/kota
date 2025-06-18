import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/colors.dart';
import '../../controller/event_controller.dart';
import '../widgets/search_bar.dart';
import 'widgets/custom_calendar.dart';
import 'widgets/today_event_card.dart';
import 'widgets/upcoming_event_card.dart';

class EventCalendarTab extends StatelessWidget {
  EventCalendarTab({Key? key}) : super(key: key);

  final EventController controller = Get.find();
  final ValueNotifier<double> radiusNotifier = ValueNotifier(20.0);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final percentage = (notification.extent - 0.5) / (0.83 - 0.5);
        radiusNotifier.value = 20 * (1 - percentage.clamp(0.0, 1.0));
        return true;
      },
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 1.h),
              CustomSearchBar(controller: controller.searchController),
              SizedBox(height: 1.h),
              CustomCalendar(),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.84,
            builder: (context, scrollController) {
              return ValueListenableBuilder<double>(
                valueListenable: radiusNotifier,
                builder: (context, radius, _) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(radius),
                      ),
                    ),
                    child: Obx(() {
                      final today = controller.todayEvents;
                      final upcoming = controller.upcomingEvents;

                      return ListView(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          if (today.isNotEmpty) ...[
                            ...today.map(
                              (event) => Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: TodayEventCard(event: event),
                              ),
                            ),
                          ] else ...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 10.h,
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.newspaper, size: 35.sp, color: Colors.grey),
                                  SizedBox(height: 1.h),
                                  const Text(
                                    "No upcoming Events",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (upcoming.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBackground,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                              child: const Text(
                                "Upcoming Events",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF839099),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ...upcoming.map(
                              (event) => Padding(
                                padding: EdgeInsets.only(bottom: 1.5.h),
                                child: UpcomingEventCard(event: event),
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
