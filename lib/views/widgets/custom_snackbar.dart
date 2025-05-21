import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; 

class CustomSnackbars {
  static void success(String message,String title) {
    _showSnackbar(title, message, Colors.green);
  }

  static void failure(String message,String title) {
    _showSnackbar(title, message, Colors.red);
  }

  static void warning(String message,String title) {
    _showSnackbar(title, message, Colors.orange);
  }

  static void oops(String message, String title) {
    _showSnackbar(title, message, Colors.grey);
  }                                                                                                                                  

  static void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
      backgroundColor:Colors.white.withOpacity(0.75),
      colorText: Colors.black,
      icon: Icon(Icons.info,size: 25.sp, color: color),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      duration: const Duration(seconds: 2),
      isDismissible: true,
      borderRadius: 8,
    );
  }
}
