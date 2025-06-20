import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Clinic Type",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 2.h),
            ClinicTypeTile(
              title: "Find Government Clinic",
              icon: Icons.local_hospital,
              onTap: () {
                controller.searchClinic(isGov: true);
                Get.to(() => ClinicResultsScreen(controller: controller));
              },
            ),
            SizedBox(height: 2.h),
            ClinicTypeTile(
              title: "Find Private Clinic",
              icon: Icons.local_hospital_outlined,
              onTap: () {
                controller.searchClinic(isGov: false);
                Get.to(() => ClinicResultsScreen(controller: controller));
              },
            ),
          ],
        ),
      );
    });
  }
}


class ClinicTypeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ClinicTypeTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryText),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
