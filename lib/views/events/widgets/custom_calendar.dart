import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/views/events/widgets/month_picker.dart';
import 'package:kota/views/events/widgets/week_header.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kota/controller/event_controller.dart';

class CustomCalendar extends StatelessWidget {
  CustomCalendar({Key? key}) : super(key: key);

  final EventController controller = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDate = controller.selectedDate.value;
      final focusedDate = controller.focusedDate.value;
      final currentYear = focusedDate.year;
      final currentMonth = focusedDate.month;

      return Column(
        children: [
          // Custom scrollable month-year picker
          MonthYearPicker(
            currentYear: currentYear,
            currentMonth: currentMonth,
            onMonthSelected: (date) {
              controller.setFocusedDate(date);
              controller.clearSelectedWeekday();
            },
          ),
          SizedBox(height: 0.5.h),
          const WeekdayHeader(),
          Divider(),
          // TableCalendar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: TableCalendar(
  rowHeight: 5.h, // 👈 Responsive row height
  daysOfWeekVisible: false,
  headerVisible: false,
  calendarStyle: CalendarStyle(
    outsideDaysVisible: false,
    todayDecoration: BoxDecoration(
      color: const Color(0xFFFF2E66).withOpacity(0.5),
      borderRadius: BorderRadius.circular(5),
    ),
    selectedDecoration: BoxDecoration(
      color: const Color(0xFFFF2E66),
      borderRadius: BorderRadius.circular(5),
    ),
    selectedTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
      color: Colors.white,
    ),
    todayTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 15.sp,
      color: Colors.white,
    ),
  ),
  pageAnimationEnabled: true,
  firstDay: DateTime(DateTime.now().year, 1, 1),
  lastDay: DateTime(DateTime.now().year, 12, 31),
  focusedDay: focusedDate,
  selectedDayPredicate: (day) => controller.isSameDate(day, selectedDate),
  onDaySelected: (selectedDay, focusedDay) {
    controller.setSelectedDate(selectedDay);
    controller.setFocusedDate(focusedDay);
    controller.updateSelectedWeekday(selectedDay);
    final DateTime normalizedMonth = DateTime(
      selectedDay.year,
      selectedDay.month,
    );
    controller.selectedMonth.value = normalizedMonth;
    controller.filterEventsByMonth(normalizedMonth);
  },
  onPageChanged: (focusedDay) {
    final DateTime normalizedMonth = DateTime(
      focusedDay.year,
      focusedDay.month,
    );
    controller.selectedMonth.value = normalizedMonth;
    controller.filterEventsByMonth(normalizedMonth);
    controller.setFocusedDate(focusedDay);
    controller.clearSelectedWeekday();
  },
  startingDayOfWeek: StartingDayOfWeek.sunday,
  calendarBuilders: CalendarBuilders(
    defaultBuilder: (context, date, _) {
      final isSelected = controller.isSameDate(date, selectedDate);
      return AnimatedScale(
        duration: const Duration(milliseconds: 300),
        scale: isSelected ? 1.1 : 1.0,
        curve: Curves.easeInOut,
        child: Container(
          width: isSelected ? 7.h : 5.h,
          height: isSelected ? 7.h : 5.h,
          decoration: BoxDecoration(
            color: isSelected ? Colors.red.shade400 : Colors.transparent,
            borderRadius: isSelected
                ? BorderRadius.circular(12)
                : BorderRadius.zero,
          ),
          alignment: Alignment.center,
          child: isSelected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  '${date.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 15.sp,
                  ),
                ),
        ),
      );
    },
  ),
),

          ),
        ],
      );
    });
  }
}
