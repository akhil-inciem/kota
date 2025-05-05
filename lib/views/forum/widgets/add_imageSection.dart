import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddImageSection extends StatefulWidget {
  const AddImageSection({super.key});

  @override
  State<AddImageSection> createState() => _AddImageSectionState();
}

class _AddImageSectionState extends State<AddImageSection> {
  final ImagePicker _picker = ImagePicker();
      XFile? _image;

  Future getImageFromGallery() async {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
      setState(() {
        _image = image;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Image",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
  children: [
    GestureDetector(
                onTap: getImageFromGallery,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 22.sp, horizontal: 24.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryBackground,
                  ),
                  child: Image.asset(
                    'assets/icons/camera.png',
                    height: 4.h,
                    width: 4.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
    SizedBox(width: 3.w),
    Stack(
      clipBehavior: Clip.none, // So close icon can overflow if needed
      children: [
        Container(
          height: 11.h,
          width: 13.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryBackground,
            image: const DecorationImage(
              image: AssetImage('assets/images/nurse-patient-wheelchair.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -10, // Adjust as per your need
          right: -10,
          child: GestureDetector(
            onTap: () {
              // TODO: handle remove image logic here
            },
            child: Container(
              height: 3.h,
              width: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primaryButton, // You can change color
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ],
),
          SizedBox(height: 4.h),
          CustomButton(
            text: "Create Discussion",
            backgroundColor: AppColors.primaryButton,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
