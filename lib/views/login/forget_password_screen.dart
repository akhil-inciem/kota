import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/login/otp_verification_Screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  bool isGuest;

  ForgotPasswordScreen({super.key, required this.isGuest});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void sendForgotPasswordRequest() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      CustomSnackbars.failure('Please enter your email', "Empty Field");
      return;
    }

    if (widget.isGuest) {
      // Call guest-specific OTP API
      final success = await authController.sendOtpToGuest(email);
      if (success) {
        CustomSnackbars.success(
          'OTP sent to your email for password reset',
          'Success',
        );
        Get.to(() => OTPVerificationScreen(email: email));
      } else {
        CustomSnackbars.failure(
          'Failed to send OTP. Please try again.',
          'Error',
        );
      }
    } else {
      // Member user flow
      final success = await authController.resetPasswordUser(email);
      if (success) {
        CustomSnackbars.success(
          'Password reset link sent to your email',
          'Success',
        );
        emailController.clear();
        authController.collapse();
        Navigator.pop(context);
      } else {
        CustomSnackbars.failure(
          'Failed to send reset link. Please try again.',
          'Error',
        );
      }
    }
  }

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

  return SafeArea(
    child: Scaffold(
      resizeToAvoidBottomInset: false, // important
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 5.w,
                right: 5.w,
                top: 2.h,
                bottom: 2.h + keyboardHeight, // avoid content hiding behind keyboard
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(),
                    SizedBox(height: 15.h),

                    /// SVG and heading
                    Center(
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/forgot_password.svg',
                            height: 13.h,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Forgot Password",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0A2C49),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.2.h),

                    /// Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Center(
                        child: Text(
                          widget.isGuest
                              ? "No worries! Enter your email to receive an OTP for password reset."
                              : "No worries! Enter your registered email and we'll send you a password reset link.",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    /// Email Input
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: LabelledTextField(
                        fillColor: Colors.white,
                        hintText: widget.isGuest
                            ? "Guest email address"
                            : "Your email address",
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return "Please enter a valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),

                    /// Subtext
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Text(
                        widget.isGuest
                            ? "Ensure you have access to this email to receive OTP."
                            : "We'll never share your email with anyone else.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
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
                    ? "Sending..."
                    : widget.isGuest
                        ? "Send OTP"
                        : "Send Reset Link",
                isEnabled: !authController.isLoading.value,
                onPressed: authController.isLoading.value
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          sendForgotPasswordRequest();
                        }
                      },
              ),
            ),
          ),
                  ],
                ),
              ),
            ),
          ),

          // Fixed button
         
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
