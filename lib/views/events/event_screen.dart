import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/event_model.dart';
import 'package:kota/views/events/widgets/custom_calendar.dart';
import 'package:kota/views/events/widgets/today_event_card.dart';
import 'package:kota/views/events/widgets/upcoming_event_card.dart';
import 'package:kota/views/home/widgets/news_list.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class EventScreen extends StatelessWidget {
  EventScreen({Key? key}) : super(key: key);

  final EventController controller = Get.find<EventController>();

  final ValueNotifier<double> radiusNotifier = ValueNotifier<double>(20.0);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        double extent =
            notification.extent; // between minChildSize and maxChildSize
        // Calculate border radius based on how much it has expanded
        double percentage = (extent - 0.5) / (0.83 - 0.5);
        double radius = 20 * (1 - percentage.clamp(0.0, 1.0));
        radiusNotifier.value = radius;
        return true;
      },
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 4.h),
              TopBar(
                isEvent: true,
              ),
              SizedBox(height: 1.h),
              CustomCalendar(),
            ],
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.38,
            maxChildSize: 0.80,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Obx(
                        () => ListView(
                          padding: EdgeInsets.zero,
                          controller: scrollController,
                          children: [
                            // Today's Events Section
                            if (controller.todayEvents.isNotEmpty) ...[
                              ...controller.todayEvents.map(
                                (event) => Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: TodayEventCard(event: event),
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,vertical: 1.h),
                                child: const Text("No events for Today",style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),),
                              ),
                              SizedBox(height: 2.h),
                            ],

                            // Upcoming Events
                            if (controller.upcomingEvents.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBackground,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 1.h,
                                  ),
                                  child: Text(
                                    "Upcoming Events",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF839099),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ...controller.upcomingEvents.map(
                                (event) => Padding(
                                  padding: EdgeInsets.only(bottom: 1.5.h),
                                  child: UpcomingEventCard(event: event),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
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
