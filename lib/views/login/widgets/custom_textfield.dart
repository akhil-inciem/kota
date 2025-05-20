import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxBool _obscureText = true.obs;

    if (!isPassword) _obscureText.value = false;

    return Obx(() => TextField(
          controller: controller,
          obscureText: _obscureText.value,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Color(0xFF839099)),
            filled: true,
            fillColor: AppColors.primaryBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText.value ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primaryButton,
                    ),
                    onPressed: () => _obscureText.toggle(),
                  )
                : null,
          ),
        ));
  }
}



