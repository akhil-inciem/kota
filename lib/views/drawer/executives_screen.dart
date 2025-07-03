import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/views/drawer/widgets/executive_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExecutivePage extends StatelessWidget {
   ExecutivePage({super.key});

  final SideMenuController menuController = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              SizedBox(height: 2.h),
              buildExecutiveList(),
            ],
          ),
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
            color: AppColors.primaryColor,
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "KOTA Executives",
          style: TextStyle(
            fontSize: 18.sp,
            color: Color(0xFF0A2C49),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildExecutiveList() {
  final executives = menuController.executiveList;
  return Obx(() {
    return Expanded(
      child: ListView.separated(
        itemCount: executives.length,
        separatorBuilder: (_, __) => SizedBox(height: 1.5.h),
        itemBuilder: (context, index) {
          final executive = executives[index];
          return ExecutiveCard(executive: executive);
        },
      ),
    );
  });
}
}
