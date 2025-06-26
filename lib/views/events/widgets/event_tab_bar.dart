import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EventTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const EventTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = ['All Events', 'Event Calendar'];
    return Column(
      children: [
        SizedBox(
          height: 4.5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onTabSelected(index),
                child: TabItem(
                  title: tabs[index],
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1, height: 0),
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const TabItem({Key? key, required this.title, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primaryText : Colors.grey.shade800,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 30.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryText : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
