import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/views/drawer/executives_screen.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../drawer/guest_reset_password_screen.dart';
import '../../login/widgets/labelled_textfield.dart';

class ChangePasswordWidget extends StatefulWidget {
  final String email;
  const ChangePasswordWidget({Key? key, required this.email}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    authController.isExpanded.value = false;
    _emailController.text = widget.email;
  }

  void _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      CustomSnackbars.failure('Please enter your email', "Empty Field");
      return;
    }
    final success = await authController.resetPasswordUser(email);
    if (success) {
      CustomSnackbars.success(
        'Password reset link sent to your email',
        'Success',
      );
      authController.collapse();
    } else {
      CustomSnackbars.failure(
        'Failed to send reset link. Please try again.',
        'Error',
      );
    }
    print('Submitted email: $email');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap:
                    authController.isGuest
                        ? () {
                          Get.to(
                            () => GuestResetPasswordScreen(email: widget.email),
                          );
                        }
                        : authController.toggleExpansion,
                child: Row(
                  children: [
                    Image.asset('assets/icons/change_password.png',
                  height: 2.5.h,
                  width: 2.5.h,
                ),
                    SizedBox(width: 5.w),
                     Text('Change Password',style: TextStyle(fontSize: 15.sp),),
                    const Spacer(),
                    authController.isGuest
                        ? SizedBox.shrink()
                        : Icon(
                          authController.isExpanded.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                              color: AppColors.primaryColor,
                        ),
                  ],
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child:
                    authController.isExpanded.value
                        ? Column(
                          children: [
                            LabelledTextField(
                              controller: _emailController,
                              
                              hintText: 'Enter your email',
                              isPassword: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!GetUtils.isEmail(value.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 1.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 4.h,
                                width: 30.w,
                                child:
                                // authController.isLoading.value
                                //     ? Center(
                                //       child: SpinKitWave(
                                //         color:
                                //             AppColors
                                //                 .primaryColor, // change to match your theme
                                //         size: 18.sp,
                                //       ),
                                //     )
                                //     :
                                CustomButton(
                                  onPressed: _submit,
                                  text: 'Submit',
                                ),
                              ),
                            ),
                          ],
                        )
                        : const SizedBox(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
