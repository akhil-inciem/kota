import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const HomeTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = ['News', 'Events'];
    return Column(
      children: [
        SizedBox(
          height: 4.5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
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
        const Divider(color: Colors.grey,  height: 0),
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
      margin: const EdgeInsets.only(right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // text sticks down
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primaryText : Colors.grey.shade800,
              fontWeight:isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 14.w,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryText : Colors.transparent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
            ),
            
          ),
        ],
      ),
    );
  }
}
