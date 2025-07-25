import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CollegeTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CollegeTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  final List<String> tabs = const ['Kerala Colleges', 'India Accredited'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 4.5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  margin:  EdgeInsets.only(right: 2.5.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.shade800,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 16.sp,
                        ),
                      ),
                       SizedBox(height: 0.5.h),
                      Container(
                        height: 0.5.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor : Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.sp),
                            topRight: Radius.circular(10.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
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
