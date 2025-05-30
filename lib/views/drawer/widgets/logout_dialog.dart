// widgets/logout_confirmation_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/controller_initializer.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final AuthController authController;

  const LogoutConfirmationDialog({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Logout ?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        CustomButton(
          width: 35.w,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          onPressed: () => Get.back(),
          text: "Cancel",
        ),
        SizedBox(height: 1.h),
        CustomButton(
          width: 35.w,
          onPressed: () async {
            Get.back();
            bool result = await authController.logout();
            if (result) {
              // await Get.delete<AuthController>();
              await Get.delete<UserController>();
              Get.offAll(() => const LoginScreen());
            } else {
              CustomSnackbars.failure(
                'Something went wrong. Please try again.',
                'Logout Failed',
              );
            }
          },
          text: "Logout",
        ),
      ],
    );
  }
}
