import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/custom_snackbar.dart';

import 'reset_password_Screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final AuthController authController = Get.find<AuthController>();
  String otpCode = '';

  void verifyOtp() async {
    if (otpCode.isEmpty || otpCode.length < 6) {
      CustomSnackbars.failure('Enter complete OTP', 'Missing Field');
      return;
    }

    final success = await authController.verifyOtp(otpCode);
    if (success) {
      Get.to(() => ResetPasswordScreen(email: widget.email));
    } else {
      CustomSnackbars.failure('Invalid OTP', 'Try Again');
    }
  }

  @override
  Widget build(BuildContext context) {
    final maskedEmail = widget.email.replaceRange(
      1,
      widget.email.indexOf('@') - 1,
      '***',
    );
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true, // 👈 Important to avoid overflow
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 6.w,vertical: 1.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/otp_verification.svg',
                            height: 13.h,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            "OTP Verification",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 19.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Enter the 6-digit code sent to\n$maskedEmail",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[700],
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          PinCodeTextField(
                            cursorColor: AppColors.primaryColor,
                            appContext: context,
                            length: 6,
                            onChanged: (value) => otpCode = value,
                            keyboardType: TextInputType.number,
                            autoFocus: true,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(2.w),
                              fieldHeight: 6.h,
                              fieldWidth: 11.w,
                              activeColor: AppColors.primaryColor,
                              inactiveColor: Colors.grey.shade300,
                              selectedColor: AppColors.primaryColor,
                              borderWidth: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => CustomButton(
                      text:
                          authController.isLoading.value
                              ? "Verifying..."
                              : "Verify OTP",
                      isEnabled: !authController.isLoading.value,
                      onPressed:
                          authController.isLoading.value ? null : verifyOtp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
