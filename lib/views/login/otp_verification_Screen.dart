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
  final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false, // prevent layout from shifting
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 4.w,
                right: 4.w,
                top: 1.h,
                bottom: 2.h + keyboardHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAppBar(),
                  SizedBox(height: 15.h),
                  SvgPicture.asset(
                    'assets/images/otp_verification.svg',
                    height: 13.h,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "OTP Verification",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A2C49),
                      fontSize: 19.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Enter the 6-digit code sent to\n$maskedEmail",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[800],
                      fontSize: 16.sp,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: PinCodeTextField(
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
                  ),
                  SizedBox(height: 15.h,),
                   Padding(
            padding: EdgeInsets.only(
              left: 2.w,
              right: 2.w,
              bottom: 2.h,
            ),
            child: Obx(
              () => CustomButton(
                text: authController.isLoading.value
                    ? "Verifying..."
                    : "Verify OTP",
                isEnabled: !authController.isLoading.value,
                onPressed:
                    authController.isLoading.value ? null : verifyOtp,
              ),
            ),
          ),
                ],
              ),
            ),
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
          onTap: () => Get.back(),
          child: Image.asset(
            'assets/icons/backbutton.png',
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "Back",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
