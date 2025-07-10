// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../login/widgets/custom_button.dart';

class GuestResetPasswordScreen extends StatefulWidget {
  final String email;
  const GuestResetPasswordScreen({super.key, required this.email});

  @override
  State<GuestResetPasswordScreen> createState() =>
      _GuestResetPasswordScreenState();
}

class _GuestResetPasswordScreenState extends State<GuestResetPasswordScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> submit() async {
  if (!_formKey.currentState!.validate()) return;

  final oldPassword = _oldPasswordController.text.trim();
  final newPassword = _newPasswordController.text.trim();

  authController.isLoading.value = true;

  final success = await authController.guestResetPassword(
    email: widget.email,
    oldPassword: oldPassword,
    newPassword: newPassword,
  );

  authController.isLoading.value = false;

  if (success) {
    CustomSnackbars.success('Password changed successfully', 'Success');
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
     Navigator.pop(context);
  } else {
    CustomSnackbars.failure('Failed to reset password. Try again.', 'Error');
  }
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),

                  SizedBox(height: 6.h),

                  // Old Password Field
                  LabelledTextField(
                    controller: _oldPasswordController,
                    label: "Old Password",
                    hintText: 'Enter previous password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Previous password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 3.h),
                  // New Password Field
                  LabelledTextField(
                    controller: _newPasswordController,
                    label: "New Password",
                    hintText: 'Enter new password',
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

                  // Confirm New Password Field
                  LabelledTextField(
                    controller: _confirmPasswordController,
                    label: "Confirm New Password",
                    hintText: 'Re-enter new password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Submit Button or Loader
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(() {
                      return SizedBox(
                        height: 5.h,
                        width: 40.w,
                        child:
                            authController.isLoading.value
                                ? const Center(
                                  child: SpinKitWave(
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                )
                                : CustomButton(
                                  onPressed: ()async{
                                    await submit();
                                  },
                                  text: 'Submit',
                                ),
                      );
                    }),
                  ),
                ],
              ),
            ),
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
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "Reset Password",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600,color: Color(0xFF0A2C49)),
        ),
      ],
    );
  }
}
