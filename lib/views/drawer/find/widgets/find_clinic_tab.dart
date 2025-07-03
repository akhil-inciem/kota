import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/views/drawer/find/clinic_list_screen.dart';
import 'package:kota/views/drawer/find/widgets/find_search_result_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FindClinicTab extends StatelessWidget {
  final FindController controller;

  const FindClinicTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClinicLoading = controller.isClinicLoading.value;

      if (isClinicLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Clinic Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Color(0xFF0A2C49))),
              SizedBox(height: 2.h),
              ClinicTypeTile(
                title: "Find Government Clinic",
                svg: 'assets/icons/gov_clinic_icon.svg',
                onTap: () {
                  controller.searchClinic(isGov: true);
                  Get.to(() => ClinicResultsScreen(controller: controller));
                },
              ),
              SizedBox(height: 2.h),
              ClinicTypeTile(
                title: "Find Private Clinic",
               svg: 'assets/icons/private_clinic_logo.svg',
                onTap: () {
                  controller.searchClinic(isGov: false);
                  Get.to(() => ClinicResultsScreen(controller: controller));
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}


class ClinicTypeTile extends StatelessWidget {
  final String title;
  final String svg;
  final VoidCallback onTap;

  const ClinicTypeTile({
    super.key,
    required this.title,
    required this.svg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBackground, // light grey background
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(
          children: [
            SvgPicture.asset(
              svg,
              color: AppColors.primaryColor,
              width: 5.w,
              height: 5.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp,color: AppColors.primaryColor,),
          ],
        ),
      ),
    );
  }
}

