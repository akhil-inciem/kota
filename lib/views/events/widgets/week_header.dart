import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WeekdayHeader extends StatelessWidget {
  const WeekdayHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventController>();

    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final isSelectedWeekday =
                controller.selectedWeekdayIndex.value == index;
            return Expanded(
              child: Center(
                child: Text(
                  DateFormat.E().dateSymbols.NARROWWEEKDAYS[index],
                  style: TextStyle(
                    fontWeight:
                        isSelectedWeekday ? FontWeight.w600 : FontWeight.normal,
                    color: isSelectedWeekday
                        ? const Color(0xFFFF2E66)
                        : const Color(0xFF839099),
                        fontSize: 15.sp
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
