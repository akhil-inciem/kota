import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String email;
  final String phoneNumber;
  final String role;

  ProfileInfoWidget({
    Key? key,
    required this.email,
    required this.phoneNumber,
    required this.role,
  }) : super(key: key);
  final authController = Get.find<AuthController>();
  final updateController = Get.find<UpdateController>();

  bool _isExpired(DateTime expiryDate) {
    final now = DateTime.now();
    return expiryDate.isBefore(now) || expiryDate.isAtSameMomentAs(now);
  }

  @override
  Widget build(BuildContext context) {
    final item = updateController.memberModel.value!.data;
    final expiryDate = item!.membershipExpiryDate!; // already DateTime
    final expired = _isExpired(expiryDate);

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
            authController.isGuest
                ? SizedBox.shrink()
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.people_alt_outlined,
                      color: Colors.black54,
                    ),
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
                          Text(
                            expired
                                ? 'Membership expired on ${DateFormat('dd MMM yyyy').format(expiryDate)}'
                                : 'Membership valid until ${DateFormat('dd MMM yyyy').format(expiryDate)}',
                            style: TextStyle(
                              color:
                                  _isExpired(item.membershipExpiryDate!)
                                      ? Colors.red
                                      : Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

            authController.isGuest || !expired
                ? SizedBox.shrink()
                : SizedBox(height: 2.h),

            authController.isGuest || !expired
                ? SizedBox.shrink()
                : Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFDD3D3D),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
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
