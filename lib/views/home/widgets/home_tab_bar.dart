import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 4.5.h, // slightly increased height to accommodate underline + text
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding:  EdgeInsets.symmetric(horizontal: 6.w),
            children: const [
              TabItem(title: 'News', isSelected: true),
              TabItem(title: 'Case Studies'),
              TabItem(title: 'Events'),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 0, // no extra spacing
        ),
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
              color: isSelected ? AppColors.primaryText : Colors.grey,
              fontWeight:isSelected ? FontWeight.bold : FontWeight.normal,
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
