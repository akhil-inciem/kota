import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/views/drawer/find/widgets/find_clinic_tab.dart';
import 'package:kota/views/drawer/find/widgets/find_therapist_tab.dart';
import 'package:kota/views/home/widgets/home_tab_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  final FindController controller = Get.put(FindController());

  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isTherapistSearched.value = false;
      controller.isClinicSearched.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1.h),
                  _buildAppBar(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),

            /// Custom Tab Bar
            FindTabBar(
              selectedIndex: selectedTabIndex,
              onTabSelected: (index) {
                setState(() {
                  selectedTabIndex = index;
                });
              },
            ),

            /// Tab content
            Expanded(
              child: Obx(() {
                if (!controller.isDropdownDataLoaded.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return IndexedStack(
                  index: selectedTabIndex,
                  children: [
                    FindTherapistTab(controller: controller),
                    FindClinicTab(controller: controller),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'assets/icons/backbutton.png',
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "Find",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600,color: Color(0xFF0A2C49)),
        ),
      ],
    );
  }
}
class FindTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const FindTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabs = ['Find a Therapist', 'Find Clinic'];
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
                child: FindTabItem(
                  title: tabs[index],
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ),
        const Divider(color: Colors.grey, height: 0),
      ],
    );
  }
}
class FindTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const FindTabItem({Key? key, required this.title, this.isSelected = false}) : super(key: key);

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
            width: 30.w,
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
