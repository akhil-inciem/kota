import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/extensions/date_extensions.dart';
import 'package:kota/model/event_model.dart';
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

          final today = <EventsDatum>[];
          final upcoming = <EventsDatum>[];
          final older = <EventsDatum>[];

          final now = DateTime.now();

          for (var event in events) {
            final eventDate = event.eventstartDateDate!;
            if (DateUtils.isSameDay(eventDate, now)) {
              today.add(event);
            } else if (eventDate.isAfter(now)) {
              upcoming.add(event);
            } else {
              older.add(event);
            }
          }

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            children: [
              if (today.isNotEmpty) ...[
                sectionHeader("Today"),
                ...today.map((e) => AllEventCard(event: e, showFullDate: false)).toList(),
              ],
              if (upcoming.isNotEmpty) ...[
                sectionHeader("Upcoming"),
                ...upcoming.map((e) => AllEventCard(event: e, showFullDate: true)).toList(),
              ],
              if (older.isNotEmpty) ...[
                sectionHeader("Older"),
                ...older.map((e) => AllEventCard(event: e, showFullDate: true)).toList(),
              ],
            ],
          );
        }),
      ),
    ],
  );
}

Widget sectionHeader(String title) {
  return Container(
    width: double.infinity,
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );
}


}

class AllEventCard extends StatelessWidget {
  final EventsDatum event;
  final bool showFullDate;

  const AllEventCard({
    required this.event,
    this.showFullDate = false,
  });

  @override
  Widget build(BuildContext context) {
    final date = event.eventstartDateDate!.toLocal();

    final dateDisplay = showFullDate
        ? DateFormat('d MMM yyyy').format(date)
        : DateFormat('d').format(date);

    final dayName = date.weekdayString;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                showFullDate ? SizedBox(): Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  dateDisplay,
                  style: TextStyle(
                    fontSize: showFullDate? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                ],
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  event.eventName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
