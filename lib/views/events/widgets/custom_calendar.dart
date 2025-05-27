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
              daysOfWeekVisible: false,
              headerVisible: false,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: Color(0xFFFF2E66).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                selectedDecoration: BoxDecoration(
                  color: Color(0xFFFF2E66),
                  borderRadius: BorderRadius.circular(5),
                ),
                selectedTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                  color: Colors.white,
                ),
              ),
              pageAnimationEnabled: true,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: focusedDate,
              selectedDayPredicate:
                  (day) => controller.isSameDate(day, selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                controller.setSelectedDate(selectedDay);
                controller.setFocusedDate(focusedDay);
                controller.updateSelectedWeekday(selectedDay);
              },
              onPageChanged: (focusedDay) {
                controller.setFocusedDate(focusedDay);
                controller
                    .clearSelectedWeekday(); // 👈 Clear highlight on month change
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
                      width: isSelected ? 70 : 50,
                      height: isSelected ? 70 : 50,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? Colors.red.shade400
                                : Colors.transparent,
                        borderRadius:
                            isSelected
                                ? BorderRadius.circular(12)
                                : BorderRadius.zero,
                      ),
                      alignment: Alignment.center,
                      child:
                          isSelected
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    '${date.day}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                              : Text(
                                '${date.day}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                    ),
                  );
                },
                // markerBuilder: (context, date, events) {
                //   if (date.day == 10) return _buildDot(Colors.purple);
                //   if (date.day == 13) return _buildDot(Colors.orange);
                //   if (date.day == 14) return _buildDot(Colors.green);
                //   if ([21, 28, 29].contains(date.day)) {
                //     return _buildDot(Colors.purple);
                //   }
                //   if (date.day == 22) return _buildDot(Colors.red);
                //   return null;
                // },
              ),
            ),
          ),
        ],
      );
    });
  }

  int _getRowIndex(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final weekOffset = firstDayOfMonth.weekday;
    return ((date.day + weekOffset - 1) / 7).floor();
  }

  String _getDayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  Widget _buildDot(Color color) {
    return Positioned(
      bottom: 1.h,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
