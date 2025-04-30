import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Icon? icon;
  final bool isGuestButton;
  final VoidCallback? onPressed;
  final double? width;  
  final double? height; 

  const CustomButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.isGuestButton = false,
    this.onPressed,
    this.width, 
    this.height, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 6.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isGuestButton
              ? Border.all(color: textColor, width: 1)
              : Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 6),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
