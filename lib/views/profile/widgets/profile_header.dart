import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/model/profile_model.dart';
import 'package:kota/views/drawer/drawer_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

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
          Positioned(
            right: 0,
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
                    const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            left: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        user.photo?.isNotEmpty == true
                            ? 'https://yourserver.com/${user.photo}'
                            : 'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=random&color=fff',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          child: const Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 10,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'KOTA Member',
                      style: TextStyle(
                        fontSize: 14,
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
