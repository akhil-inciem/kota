import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddImageSection extends StatelessWidget {
  AddImageSection({super.key});

  final ForumController _forumController = Get.find<ForumController>();
  final ImagePicker _picker = ImagePicker();

  Future<void> getImagesFromGallery() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      for (final image in pickedImages) {
        _forumController.addImage(image); // using controller method
      }
    }
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
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              GestureDetector(
                onTap: getImagesFromGallery,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 22.sp,
                    horizontal: 24.sp,
                  ),
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
              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_forumController.selectedImages.length, (index) {
                        final image = _forumController.selectedImages[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 2.w, top: 1.h),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 11.h,
                                width: 13.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primaryBackground,
                                  image: DecorationImage(
                                    image: FileImage(File(image.path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -1.h,
                                right: -1.w,
                                child: GestureDetector(
                                  onTap: () => _forumController.removeImage(index),
                                  child: Container(
                                    height: 2.5.h,
                                    width: 2.5.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryButton,
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
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
         
        ],
      ),
    );
  }
}
