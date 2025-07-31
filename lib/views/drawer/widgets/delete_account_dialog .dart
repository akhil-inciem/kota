import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/login/login_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeleteAccountDialog extends StatelessWidget {
  final AuthController authController;

  const DeleteAccountDialog({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Delete Account?",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Are you sure you want to delete your account? This action cannot be undone."),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                width: 30.w,
                textColor: Colors.black,
                backgroundColor: Colors.white,
                onPressed: () => Get.back(),
                text: "Cancel",
              ),
              SizedBox(width: 5.w),
              CustomButton(
                width: 30.w,
                backgroundColor: Colors.red,
                onPressed: () async {
                  Get.back();
                  bool result = await authController.deleteAccount();
                  if (result) {
                    await Get.delete<UserController>();
                    Get.offAll(() => const LoginScreen());
                  } else {
                    CustomSnackbars.failure(
                      'Failed to delete account. Please try again.',
                      'Deletion Failed',
                    );
                  }
                },
                text: "Delete",
              ),
            ],
          )
        ],
      ),
    );
  }
}
