import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../forget_password_screen.dart';

class GuestMemberDialog extends StatelessWidget {
  const GuestMemberDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      title: const Text("Who are you?"),
      content: const Text("Please select your user type."),
      actionsPadding: EdgeInsets.all(15.sp), // Bottom padding added
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButton(
                text: "Guest",
                width: 60.w,
                onPressed: () {
                  Get.back(); 
                  Get.to(() => ForgotPasswordScreen(isGuest: true));
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: "Member",
                width: 60.w,
                onPressed: () {
                  Get.back(); 
                  Get.to(() => ForgotPasswordScreen(isGuest: false));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
