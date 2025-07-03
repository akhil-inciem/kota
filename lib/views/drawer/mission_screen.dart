// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:html/parser.dart' show parse;

class MissionPage extends StatelessWidget {
  MissionPage({super.key});

  final SideMenuController controller = Get.find<SideMenuController>();

  String cleanHtml(String htmlString) {
    final document = parse(htmlString);
    final text = document.body?.text.trim() ?? '';
    return text.replaceAll(RegExp(r'\n\s*'), '\n').trim();
  }

  List<String> extractBulletPoints(String htmlString) {
    final document = parse(htmlString);
    final liElements = document.getElementsByTagName('li');

    if (liElements.isEmpty) {
      return [cleanHtml(htmlString)];
    }

    return liElements.map((e) => e.text.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/icons/backbutton.png',
                      // color: Colors.black,
                      width: 6.w,
                      height: 2.5.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Vision & Mission",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Color(0xFF0A2C49),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Scrollable content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.visionMission.isEmpty) {
                    return const Center(
                      child: Text("No Vision or Mission data available."),
                    );
                  }

                  final rawVision =
                      controller.visionMission.first.vision ?? "N/A";
                  final rawMission =
                      controller.visionMission.first.mission ?? "N/A";

                  final visionBullets = extractBulletPoints(rawVision);
                  final missionBullets = extractBulletPoints(rawMission);

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildInfoCard(
                          title: "Our Mission",
                          bulletPoints: missionBullets,
                        ),
                        SizedBox(height: 3.h),
                        _buildInfoCard(
                          title: "Our Vision",
                          bulletPoints: visionBullets,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<String> bulletPoints,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 1.h),
          ...bulletPoints.map(
            (point) => Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
