import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool get isMatching =>
      passwordController.text.trim().isNotEmpty &&
      confirmPasswordController.text.trim().isNotEmpty &&
      passwordController.text.trim() == confirmPasswordController.text.trim();

  void resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.resetGuestPassword(passwordController.text.trim());
    if (success) {
      CustomSnackbars.success('Password updated', 'Success');
      Get.offAll(LoginScreen());
    } else {
      CustomSnackbars.failure('Password reset failed', 'Failed');
    }
  }

  @override
  void initState() {
    super.initState();
    passwordController.addListener(() => setState(() {}));
    confirmPasswordController.addListener(() => setState(() {}));
  }

 @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);

  return Scaffold(
    backgroundColor: AppColors.primaryBackground,
    resizeToAvoidBottomInset: true, 
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h,),
                  /// Title
                  Text(
                    "Set New Password",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  Text(
                    "Enter your new password below to complete the reset process.",
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
                  SizedBox(height: 4.h),
        
                  /// Password Fields
                  LabelledTextField(
                    controller: passwordController,
                    hintText: "New Password",
                    fillColor: Colors.white,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  LabelledTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    fillColor: Colors.white,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
        
                  Spacer(),
        
                  /// Submit Button
                  Obx(() => CustomButton(
                        text: authController.isLoading.value
                            ? "Updating..."
                            : "Reset Password",
                        isEnabled: isMatching && !authController.isLoading.value,
                        onPressed: isMatching && !authController.isLoading.value
                            ? resetPassword
                            : null,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

}

