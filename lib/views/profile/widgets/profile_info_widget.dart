import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String email;
  final String phoneNumber;
  final String role;

  const ProfileInfoWidget({
    Key? key,
    required this.email,
    required this.phoneNumber,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            // Email Row
            Row(
              children: [
                const Icon(Icons.email_outlined, color: Colors.black54),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    email,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Phone Row
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: Colors.black54),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Role and Expiry Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.people_alt_outlined, color: Colors.black54),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      const Text(
                        'Expired - 01 Jan 2014 to 30 Jan 2024',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFDD3D3D),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: const Text(
                    "Renew Membership",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
