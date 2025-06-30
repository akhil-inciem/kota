import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/login/widgets/custom_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LabelledTextField extends StatelessWidget {
  final String? label; // Normal label
  final String? rightLabel; // Right side label (optional)
  final VoidCallback? onRightLabelTap; // Right label tap action
  final String hintText;
  final IconData? icon;
  final Color? fillColor;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const LabelledTextField({
    Key? key,
    this.label,
    this.rightLabel,
    this.onRightLabelTap,
    this.fillColor,
    required this.hintText,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget labelWidget;

    if (rightLabel != null) {
      labelWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label ?? '',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: onRightLabelTap,
            child: Text(
              rightLabel!,
              style: TextStyle(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    } else {
      labelWidget = Text(
        label ?? '',
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget,
        SizedBox(height: 0.3.h),
        CustomTextField(
          fillColor: fillColor,
          icon: icon,
          hintText: hintText,
          controller: controller,
          isPassword: isPassword,
          validator: validator,
        ),
      ],
    );
  }
}
