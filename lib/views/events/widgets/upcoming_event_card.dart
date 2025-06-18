import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kota/extensions/date_extensions.dart';
import 'package:kota/helper/date_helper.dart';
import 'package:kota/model/event_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpcomingEventCard extends StatelessWidget {
  final EventsDatum event;

  const UpcomingEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 6.w,vertical: 1.h),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left part: Date and Weekday
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('d').format(event.eventstartDateDate!.toLocal()),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          // color: event.color,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        event.eventstartDateDate!.toLocal().weekdayString,
                        style: TextStyle(
                          fontSize: 14,
                          // color: event.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 4.w),
          
                  // Right part: Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.eventName!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          
              // Bottom-right: Time container
              Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.5.h, vertical: 0.5.h),
            decoration: BoxDecoration(
              // color: event.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  // color: event.color,
                ),
                SizedBox(width: 4),
                Text(
                  formatDate(event.addedOn!), // This will be like "18:00 IST"
                  style: TextStyle(
                    fontSize: 10,
                    // color: event.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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

