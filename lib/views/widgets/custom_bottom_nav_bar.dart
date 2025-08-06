import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int newUpdatesCount; 


  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.newUpdatesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.5.w),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.sp),
          topRight: Radius.circular(18.sp),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: ClipRRect(
        child: SizedBox(
          height: 9.h,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12.sp,
            unselectedFontSize: 11.sp,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            currentIndex: currentIndex,
            onTap: onTap,
            items: [
              _buildNavItem(
                selectedIcon: 'assets/icons/home_selected.png',
                unselectedIcon: 'assets/icons/home_unselected.png',
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                selectedIcon: 'assets/icons/event_selected.png',
                unselectedIcon: 'assets/icons/event_unselected.png',
                label: 'Events',
                index: 1,
              ),
              _buildNavItem(
                selectedIcon: 'assets/icons/forum_selected.png',
                unselectedIcon: 'assets/icons/forum_unselected.png',
                label: 'Forum',
                index: 2,
              ),
              _buildNavItem(
                selectedIcon: 'assets/icons/favorites_selected.png',
                unselectedIcon: 'assets/icons/favorites_unselected.png',
                label: 'Favourites',
                index: 3,
              ),
              _buildNavItem(
                selectedIcon: 'assets/icons/updates_selected.png',
                unselectedIcon: 'assets/icons/updates_unselected.png',
                label: 'Updates',
                index: 4,
                showDot: newUpdatesCount > 0 ,
                dotCount: newUpdatesCount, // 👈 dynamic red dot
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
  required String selectedIcon,
  required String unselectedIcon,
  required String label,
  required int index,
  bool showDot = false,
  int dotCount = 0,
})
 {
    return BottomNavigationBarItem(
  icon: Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          currentIndex == index ? selectedIcon : unselectedIcon,
          width: 19.sp,
          height: 19.sp,
        ),
        if (showDot)
          Positioned(
            top: -8.sp,
            right: -10.sp,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:8.sp, vertical: 2.sp),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints:  BoxConstraints(
                minWidth: 14.sp,
                minHeight: 14.sp,
              ),
              child: Center(
                child: Text(
                  dotCount > 99 ? '99+' : '$dotCount',
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  ),
  label: label,
);

  }
}
