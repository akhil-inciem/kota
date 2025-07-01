import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final Color? fillColor;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.fillColor,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxBool _obscureText = isPassword.obs;

    return Obx(
      () => TextFormField(
        controller: controller,
        obscureText: _obscureText.value,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF839099)),
          filled: true,
          fillColor: fillColor ?? AppColors.primaryBackground,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 1.3.h, // balanced vertical padding
            horizontal: 4.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.primaryColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          suffixIcon: isPassword
              ? Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: IconButton(
                    icon: Icon(
                      _obscureText.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () => _obscureText.toggle(),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
