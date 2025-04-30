import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/views/drawer/drawer_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Avatar and Name at Bottom Left
          Positioned(
            bottom: 25,
            left: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/300',
                      ), // Replace with user's profile image
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
                          child: Center(
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
                  children: const [
                    Text(
                      'John Alexander',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
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

  Widget _buildDrawerButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Get.to(()=>DrawerPage());
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        'assets/icons/drawer_icon.png',
        color: Colors.white,
        width: 6.w,
        height: 2.5.h,
        fit: BoxFit.contain,
      ),
    ),
  );
}
}