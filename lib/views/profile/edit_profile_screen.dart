import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:kota/views/profile/widgets/shimmer/edit_profile_button_shimmer.dart';
import 'package:kota/views/profile/widgets/shimmer/edit_profile_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userController = Get.find<UserController>();
  final authController = Get.find<AuthController>();

  void pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      userController.setProfileImage(File(pickedFile.path));
    } else {}
  }

  @override
  void initState() {
    userController.clearFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: AppColors.primaryBackground,
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        final user = userController.user.value;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 2.h),
                  _buildAppBar(), // ✅ Always shown

                  if 
                  // (isLoading) ...[
                  //   SizedBox(height: 4.h),
                  //   const EditProfileShimmer(),
                  //   SizedBox(height: 4.h),
                  //   const ShimmerButtonPlaceholder(),
                  //   SizedBox(height: 3.h),
                  // ] else if 
                  (user == null) ...[
                    SizedBox(height: 4.h),
                    const Center(
                      child: Text(
                        'Failed to load user data',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 4.h),
                   authController.isGuest ? SizedBox() : _buildProfilePictureSection(user),
                    SizedBox(height: 4.h),
                    _buildFormSection(userController),
                    SizedBox(height: 4.h),
                    Obx(
  () => CustomButton(
    text: userController.isLoading.value ? "Updating..." : "Update",
    isEnabled: userController.isChanged.value && !userController.isLoading.value,
    onPressed: (userController.isChanged.value && !userController.isLoading.value)
        ? () => userController.updateUserProfile()
        : null,
  ),
),

                    SizedBox(height: 3.h),
                  ]
                ],
              ),
            ),
          ),
        );
      }),
    ),
  );
}
  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            'assets/icons/backbutton.png',
            color: Colors.black,
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "Edit profile",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProfilePictureSection(user) {
    return Obx(() {
      final selectedImage = userController.selectedImage.value;
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 8.h,
              backgroundImage:
                  selectedImage != null
                      ? FileImage(selectedImage)
                      : (user.photo != null && user.photo!.isNotEmpty
                          ? NetworkImage(user.photo!) as ImageProvider
                          : null),
              backgroundColor: Colors.grey[200],
              child:
                  selectedImage == null &&
                          (user.photo == null || user.photo!.isEmpty)
                      ? Icon(Icons.person, size: 8.h, color: Colors.grey[400])
                      : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryButton,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: _showImagePickerDialog,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFormSection(UserController userController) {
    final isGuest = authController.isGuest;
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          LabelledTextField(
            label: isGuest ? "Full Name" : "First Name",
            hintText:
                isGuest ? "Enter your full name" : "Enter your first name",
            controller: userController.firstNameController,
          ),
          if (!isGuest) ...[
            SizedBox(height: 3.h),
            LabelledTextField(
              label: "Last Name",
              hintText: "Enter your last name",
              controller: userController.lastNameController,
            ),
          ],
          SizedBox(height: 3.h),
          LabelledTextField(
            label: "Phone Number",
            hintText: "Enter your phone number",
            controller: userController.phoneController,
          ),
          SizedBox(height: 3.h),
          LabelledTextField(
            label: "Email",
            hintText: "Enter your email address",
            controller: userController.emailController,
          ),
        ],
      ),
    );
  }

  void _showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(6.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Change Profile Picture",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.camera);
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Get.back();
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 25.sp, color: AppColors.primaryButton),
            SizedBox(height: 1.h),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
