import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/views/drawer/find/widgets/find_search_result_widget.dart' show SearchResultTherapistWidget;
import 'package:responsive_sizer/responsive_sizer.dart';

class TherapistResultsScreen extends StatelessWidget {
  final FindController controller;

  const TherapistResultsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: _buildAppBar(),
            ),

            // Results Section
            Expanded(
              child: Obx(() {
                final results = controller.filteredTherapistList;
                return SearchResultTherapistWidget(
                  results: results.toList(),
                  onSearch: controller.filterTherapists,
                  onReset: () {
                    controller.resetTherapistSearch();
                    Get.back(); // Go back to the form screen
                  },
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
            controller.resetTherapistSearch();
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
          "Back",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
