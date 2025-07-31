import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'widgets/find_search_result_widget.dart';

class ClinicResultsScreen extends StatelessWidget {
  final FindController controller;

  const ClinicResultsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: _buildAppBar(),
            ),

            // Results Section
            Expanded(
              child: Obx(() {
                final results = controller.filteredClinicList;
                return SearchResultClinicWidget(
                  results: results.toList(),
                  onSearch: controller.filterClinics,
                  onReset: () {
                    controller.resetClinicSearch();
                    Get.back(); // Go back to the previous screen
                  }, controller: controller,
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
          onTap: () {
            controller.resetClinicSearch();
            Get.back();
          },
          child: Image.asset(
            'assets/icons/backbutton.png',
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          controller.isPrivateClinic.value ? "Find Private Clinic":
          "Find Government Clinic",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0A2C49)
          ),
        ),
      ],
    );
  }
}
