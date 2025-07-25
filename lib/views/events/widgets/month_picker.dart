import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MonthYearPicker extends StatefulWidget {
  final int currentYear;
  final int currentMonth;
  final Function(DateTime) onMonthSelected;

  const MonthYearPicker({
    Key? key,
    required this.currentYear,
    required this.currentMonth,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedMonth();
    });
  }

  @override
  void didUpdateWidget(covariant MonthYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMonth != widget.currentMonth) {
      _scrollToSelectedMonth();
    }
  }

  void _scrollToSelectedMonth() {
    final double itemWidth = 25.w;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetOffset =
        (widget.currentMonth - 1) * itemWidth - (screenWidth - itemWidth) / 2;

    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) {
            final DateTime date = DateTime(widget.currentYear, index + 1);
            final monthYear = DateFormat('MMM yyyy').format(date);
            final isSelected = index + 1 == widget.currentMonth;
            return GestureDetector(
              onTap: () {
                widget.onMonthSelected(
                  DateTime(widget.currentYear, index + 1, 1),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Container(
                  width: 25.w,
                  alignment: Alignment.center,
                  child: Text(
                    monthYear,
                    style: TextStyle(
                      color:
                          isSelected
                              ? AppColors.primaryText
                              : Color(0xFFA8B7C2),
                      fontSize: 16.sp,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
