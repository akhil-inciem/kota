import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/drawer_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/drawer/contact_us_screen.dart';
import 'package:kota/views/drawer/executives_screen.dart';
import 'package:kota/views/drawer/faq.screen.dart';
import 'package:kota/views/drawer/find/find_screen.dart';
import 'package:kota/views/drawer/mission_screen.dart';
import 'package:kota/views/drawer/ot_colleges_screen.dart';
import 'package:kota/views/drawer/widgets/delete_account_dialog%20.dart';
import 'package:kota/views/profile/profile_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/auth_controller.dart';
import 'widgets/logout_dialog.dart';

class DrawerPage extends StatelessWidget {
  DrawerPage({Key? key}) : super(key: key);

  final authController = Get.find<AuthController>();
  final SideMenuController menuController = Get.put(SideMenuController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Column(
          children: [
            DrawerHeaderWidget(),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                children: [
                  ViewProfileItem(),
                  SizedBox(height: 0.5.h),
                  ...[
                        DrawerItem(
                          icon: 'assets/icons/vision&mission.png',
                          title: 'Vision & Mission',
                          onPressed: () => Get.to(() => MissionPage()),
                        ),
                        DrawerItem(
                          icon: 'assets/icons/executives.png',
                          title: 'KOTA Executives',
                          onPressed: () => Get.to(() => ExecutivePage()),
                        ),
                        DrawerItem(
                          icon: 'assets/icons/executives.png',
                          title: 'OT Colleges',
                          onPressed: () => Get.to(() => CollegesScreen()),
                        ),
                        DrawerItem(
                          icon: 'assets/icons/contct_us.png',
                          title: 'Contact Us',
                          onPressed: () => Get.to(() => ContactUsScreen()),
                        ),
                        DrawerItem(
                          icon: 'assets/icons/faq.png',
                          title: 'FAQ',
                          onPressed: () => Get.to(() => FaqScreen()),
                        ),
                        DrawerItem(
                          icon: 'assets/icons/find.png',
                          title: 'Find',
                          onPressed: () => Get.to(() => FindScreen()),
                        ),
                        DrawerItem(
                          icon: 'assets/icons/delete.png',
                          title: 'Delete Account',
                          onPressed: () {
                            Get.dialog(
                              DeleteAccountDialog(
                                authController: authController,
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                        DrawerItem(
                          icon: 'assets/icons/logout.png',
                          title: 'Logout',
                          onPressed: () {
                            Get.dialog(
                              LogoutConfirmationDialog(
                                authController: authController,
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                      ]
                      .expand((item) => [item, SizedBox(height: 1.h)])
                      .toList(), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  DrawerHeaderWidget({Key? key}) : super(key: key);

  final userController = Get.find<UserController>();
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
          // Background image
          Positioned(
            right: -2.h,
            top: 2.5.h,
            bottom: 0,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/drawertop_bg.png',
                width: 80.w,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Close button
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                  child: Icon(Icons.close, size: 23.sp, color: Colors.white),
                  onTap: () => Get.back(),
                ),
              ),
            ),
          ),

          // Avatar and user info
          Positioned(
            bottom: 2.5.h,
            left: 3.h,
            child: Obx(() {
              final user = userController.user.value;

              if (user == null) {
                return SizedBox(height: 7.h, width: 7.h);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 7.h,
                    width: 7.h,
                    child:
                        user.photo?.isNotEmpty == true
                            ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.photo!,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(color: Colors.grey),
                                    ),
                                errorWidget:
                                    (context, url, error) => Icon(
                                      Icons.person,
                                      size: 24.sp,
                                      color: Colors.grey,
                                    ),
                              ),
                            )
                            : CircleAvatar(
                              radius: 3.h,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 24.sp,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName}${user.lastName != null && user.lastName!.isNotEmpty ? ' ${user.lastName}' : ''}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
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
              );
            }),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String icon;
  final String title;
  final Function()? onPressed;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 5.w,
      ), // tighter horizontal padding
      dense: true, // reduces overall height
      horizontalTitleGap: 1.h, // spacing between icon and text

      leading: Image.asset(icon, height: 2.5.h, width: 2.5.h),
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400),
      ),
      onTap: onPressed,
    );
  }
}

class ViewProfileItem extends StatelessWidget {
  const ViewProfileItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
        horizontalTitleGap: 2.w,
        leading: Image.asset(
          'assets/icons/profile.png',
          height: 2.5.h,
          width: 2.5.h,
          fit: BoxFit.contain,
        ),
        title: Text(
          'View Profile',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
        onTap: () => Get.to(() => ProfilePage()),
      ),
    );
  }
}
