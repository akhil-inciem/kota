import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);


final int notificationCount = 99; 

  @override

  
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        child: SizedBox(
          height: 85, // Slightly reduced height for balance
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryButton,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 11,
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
    badgeCount: notificationCount, // 👈 inject here
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
  int? badgeCount,
}) {
  bool isUpdatesTab = index == 4 && badgeCount != null && badgeCount > 0;

  return BottomNavigationBarItem(
    icon: Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            currentIndex == index ? selectedIcon : unselectedIcon,
            width: 22,
            height: 22,
          ),
          // if (isUpdatesTab)
          //   Positioned(
          //     top: -4,
          //     right: -6,
          //     child: Container(
          //       height: 2.h,
          //       width: 2.h,
          //       // padding: const EdgeInsets.symmetric(horizontal: 2,),
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       constraints: const BoxConstraints(minWidth: 16),
          //       child: Center(
          //         child: Text(
          //           badgeCount! > 99 ? '99+' : badgeCount.toString(),
          //           style:  TextStyle(
          //             color: Colors.white,
          //             fontSize: 12.sp,
          //             fontWeight: FontWeight.bold,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    ),
    label: label,
  );
}

}