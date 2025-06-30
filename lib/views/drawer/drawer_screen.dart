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
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ViewProfileItem(),
                  DrawerItem(
                    icon: Icons.track_changes_outlined,
                    title: 'Vision & Mission',
                    onPressed: () {
                      Get.to(() => MissionPage());
                    },
                  ),
                  DrawerItem(
                    icon: Icons.group_outlined,
                    title: 'KOTA Executives',
                    onPressed: () {
                      Get.to(() => ExecutivePage());
                    },
                  ),
                  DrawerItem(
                    icon: Icons.school,
                    title: 'OT Colleges',
                    onPressed: () {
                      Get.to(() => CollegesScreen());
                    },
                  ),
                  DrawerItem(
                    icon: Icons.contact_mail_outlined,
                    title: 'Contact Us',
                    onPressed: () {
                      Get.to(() => ContactUsScreen());
                    },
                  ),
                  DrawerItem(
                    icon: Icons.help_outline,
                    title: 'FAQ',
                    onPressed: () {
                      Get.to(() => FaqScreen());
                    },
                  ),
                  DrawerItem(
                    icon: Icons.send_outlined,
                    title: 'Find',
                    onPressed: () => Get.to(() => FindScreen()),
                  ),
                  DrawerItem(
                    icon: Icons.logout,
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
      height: 30.h,
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
            right: 0,
            top: 25,
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
                  child: const Icon(Icons.close, size: 35, color: Colors.white),
                  onTap: () => Get.back(),
                ),
              ),
            ),
          ),

          // Avatar and user info
          Positioned(
            bottom: 25,
            left: 30,
            child: Obx(() {
              final user = userController.user.value;

              if (user == null) {
                return const SizedBox(height: 60, width: 60);
              }

              final imageUrl = user.photo?.isNotEmpty == true
                  ? user.photo!
                  : 'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName ?? ''}&background=random&color=fff';

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName}${user.lastName != null && user.lastName!.isNotEmpty ? ' ${user.lastName}' : ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authController.isGuest ? "KOTA Guest" : "KOTA Member",
                        style: const TextStyle(
                          fontSize: 14,
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
  final IconData icon;
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Container(
        decoration: const BoxDecoration(color: AppColors.primaryBackground),
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}

class ViewProfileItem extends StatelessWidget {
  const ViewProfileItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.5.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Retain white background
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          leading: const Icon(Icons.person_outline, color: Colors.black),
          title: const Text(
            'View Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          onTap: () => Get.to(() => ProfilePage()),
        ),
      ),
    );
  }
}


