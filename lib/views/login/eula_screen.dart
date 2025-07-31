import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/base.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EulaScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  EulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top blue header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10.h, bottom: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.sp),
                bottomRight: Radius.circular(25.sp),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "End User License Agreement",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Kota App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "By using this app, you agree to the following terms and conditions:",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 2.h),

                    _buildSectionTitle("1. Zero Tolerance Policy"),
                    _buildBullet("No objectionable, illegal, harmful, or abusive content is allowed."),
                    _buildBullet("Harassment, hate speech, nudity, or threatening behavior will lead to immediate suspension."),

                    SizedBox(height: 2.h),
                    _buildSectionTitle("2. Content Moderation"),
                    _buildBullet("The app includes content filtering and reporting tools."),
                    _buildBullet("Users may report content or block other users."),
                    _buildBullet("Reported content will be reviewed within 24 hours."),

                    SizedBox(height: 2.h),
                    _buildSectionTitle("3. Accountability"),
                    _buildBullet("You are responsible for the content you post or interact with."),
                    _buildBullet("Violations of these terms may result in account deactivation."),

                    SizedBox(height: 2.h),
                    _buildSectionTitle("4. Privacy & Data"),
                    _buildBullet("Your data is handled according to our privacy policy."),
                    _buildBullet("You can request deletion of your account and associated data."),

                    SizedBox(height: 2.h),
                    Text(
                      'By tapping "I Agree", you confirm that you have read, understood, and accepted this agreement',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // I Agree Button
          Padding(
            padding: EdgeInsets.only(left: 6.w,right: 6.w, top: 1.h,bottom: 4.h),
            child: CustomButton(
              text: "I Agree",
              backgroundColor: AppColors.primaryColor,
              onPressed: () async {
                bool updated = await authController.acceptEula();
                if (updated) {
                  Get.offAll(() => BaseScreen());
                } else {
                  Get.snackbar(
                    "Error",
                    "Something went wrong. Please try again.",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, top: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontSize: 16.sp)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }
}
