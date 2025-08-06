import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/profile/widgets/aiota_cerificate.dart';
import 'package:kota/views/profile/widgets/kota_certifcate_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CertificateScreen extends StatelessWidget {
  final String name;
  final String issuedOn;
  final String validTill;
  final String userPhotoPath;
  final String aiotaCertificate;

  const CertificateScreen({
    super.key,
    required this.name,
    required this.issuedOn,
    required this.validTill,
    required this.userPhotoPath,
    required this.aiotaCertificate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              _buildAppBar(),
              SizedBox(height: 3.h),
              KotaCertificateWidget(
                name: name,
                issuedOn: issuedOn,
                validTill: validTill,
                userPhotoPath: userPhotoPath,
              ),
              SizedBox(height: 4.h),
              AiotaCertificateWidget(imagePath: aiotaCertificate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
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
            "Cerificates",
            style: TextStyle(
              fontSize: 18.sp,
              color: Color(0xFF0A2C49),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
