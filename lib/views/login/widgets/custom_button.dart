import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Icon? icon;
  final bool isGuestButton;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isEnabled;

  const CustomButton({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isGuestButton = false,
    this.onPressed,
    this.width,
    this.height,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultBg = AppColors.primaryColor;
    final defaultText = Colors.white;

    final effectiveBackgroundColor = isEnabled
        ? (backgroundColor ?? defaultBg)
        : (backgroundColor ?? defaultBg).withOpacity(0.4);
    final effectiveTextColor = isEnabled
        ? (textColor ?? defaultText)
        : (textColor ?? defaultText).withOpacity(0.6);

    return GestureDetector(
      
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 6.h,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(14.sp),
          border: isGuestButton
              ? Border.all(color: effectiveTextColor, width: 1)
              : Border.all(color: Colors.transparent),
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 2.w),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: 0.5.h),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: effectiveTextColor,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

