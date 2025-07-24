import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/model/profile_model.dart';
import 'package:kota/views/drawer/drawer_screen.dart';
import 'package:kota/views/profile/edit_profile_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  ProfileHeader({Key? key, required this.user}) : super(key: key);
  final authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF015FC9), Color(0xFF7001C5)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -4.h,
            top: 8.h,
            bottom: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/drawertop_bg.png',
                width: 70.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Image.asset(
                        'assets/icons/backbutton.png',
                        color: Colors.white,
                        width: 6.w,
                        height: 2.5.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 4.w),
                     Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Positioned(
  bottom: 2.5.h,
  left: 3.h,
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Avatar + Edit button
      Column(
        children: [
          SizedBox(height: 3.h,),
          user.photo?.isNotEmpty == true
    ? CircleAvatar(
        radius: 3.h,
        backgroundImage: CachedNetworkImageProvider(user.photo!),
      )
    :  CircleAvatar(
        radius: 3.h,
        backgroundColor: Colors.grey.shade200,
        child: Icon(
          Icons.person,
          size: 24.sp,
          color: Colors.grey,
        ),
      )
,
           SizedBox(height: 1.h),
          GestureDetector(
            onTap: () {
              Get.to(() => EditProfileScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 0.4.h,
                ),
                child: Center(
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(width: 15),

      // Name and Role (centered to avatar, not column)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${user.firstName}${user.lastName != null && user.lastName!.isNotEmpty ? ' ${user.lastName}' : ''}',
            style:  TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            authController.isGuest ? "KOTA Guest" : "KOTA Member",
            style: TextStyle(
              fontSize: 14.sp,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    ],
  ),
),
      ],
      ), 
    );
  }
}
