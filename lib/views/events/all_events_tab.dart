import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controller/event_controller.dart';
import '../widgets/search_bar.dart';
import 'widgets/upcoming_event_card.dart';

class AllEventsTab extends StatelessWidget {
  AllEventsTab({Key? key}) : super(key: key);

  final EventController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        Expanded(
          child: Obx(() {
            final events = controller.filteredEventsItems;

            if (events.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.newspaper, size: 35.sp, color: Colors.grey),
                      SizedBox(height: 1.h),
                      const Text(
                        "No events available",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: events.length,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(bottom: 1.5.h),
                child: UpcomingEventCard(event: events[i]),
              ),
            );
          }),
        ),
      ],
    );
  }
}
