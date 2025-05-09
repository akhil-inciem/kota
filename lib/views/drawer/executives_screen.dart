import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/drawer/widgets/executive_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExecutivePage extends StatelessWidget {
  const ExecutivePage({super.key});

  static const List<Map<String, String>> executives = [
    {
      "name": "Dr. Alice Smith",
      "phone": "+1 234 567 890",
      "email": "alice.smith@example.com",
      "image": "assets/images/certificate.jpg",
    },
    {
      "name": "Dr. Bob Johnson",
      "phone": "+1 987 654 321",
      "email": "bob.johnson@example.com",
      "image": "assets/images/recommend_tile.jpg",
    },
    {
      "name": "Dr. Alice Smith",
      "phone": "+1 234 567 890",
      "email": "alice.smith@example.com",
      "image": "assets/images/certificate.jpg",
    },
    {
      "name": "Dr. Bob Johnson",
      "phone": "+1 987 654 321",
      "email": "bob.johnson@example.com",
      "image": "assets/images/recommend_tile.jpg",
    },
    {
      "name": "Dr. Alice Smith",
      "phone": "+1 234 567 890",
      "email": "alice.smith@example.com",
      "image": "assets/images/certificate.jpg",
    },
    {
      "name": "Dr. Bob Johnson",
      "phone": "+1 987 654 321",
      "email": "bob.johnson@example.com",
      "image": "assets/images/recommend_tile.jpg",
    },
  ];

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
              _buildExecutiveGrid(),
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
            color: Colors.black,
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "KOTA Executives",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExecutiveGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: executives.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.w,
          mainAxisExtent: 36.h,
        ),
        itemBuilder: (context, index) {
          final executive = executives[index];
          return ExecutiveCard(executive: executive);
        },
      ),
    );
  }
}
