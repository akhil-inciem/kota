import 'package:flutter/material.dart';
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
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14,color: Color(0xFF839099)),
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
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Reduced height
      ),
    );
  }
}


