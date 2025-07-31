import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/updates_controller.dart' show UpdateController;
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileInfoWidget extends StatefulWidget {
  final String email;
  final String phoneNumber;
  final String role;

  ProfileInfoWidget({
    Key? key,
    required this.email,
    required this.phoneNumber,
    required this.role,
  }) : super(key: key);

  @override
  State<ProfileInfoWidget> createState() => _ProfileInfoWidgetState();
}

class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {
  final authController = Get.find<AuthController>();
  final updateController = Get.put(UpdateController());

  DateTime? _lastCopyTime;

  bool _isExpired(DateTime expiryDate) {
    final now = DateTime.now();
    return expiryDate.isBefore(now) || expiryDate.isAtSameMomentAs(now);
  }

  void _copyToClipboard(String text, String label) {
  final now = DateTime.now();

  if (_lastCopyTime == null || now.difference(_lastCopyTime!) > const Duration(seconds: 1)) {
    Clipboard.setData(ClipboardData(text: text));
    _lastCopyTime = now;

    Fluttertoast.showToast(
      msg: "$label copied",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}

  @override
Widget build(BuildContext context) {
  final member = updateController.memberModel.value;
  final item = member?.data;
  final expiryDate = item?.membershipExpiryDate;
  final expired = expiryDate != null ? _isExpired(expiryDate) : false;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),

          /// Email Row
          Row(
            children: [
              Image.asset('assets/icons/email.png',
                  height: 2.h,
                  width: 2.h,
                ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  widget.email,
                  style:  TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _copyToClipboard(widget.email, "Email"),
                child:  Icon(Icons.copy, size: 19.sp, color: Colors.black54),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          /// Phone Row
          Row(
            children: [
              Image.asset('assets/icons/phone.png',
                  height: 2.h,
                  width: 2.h,
                ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  widget.phoneNumber,
                  style:  TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              InkWell(
                onTap: () => _copyToClipboard(widget.phoneNumber, "Phone number"),
                child: Icon(Icons.copy, size: 19.sp, color: Colors.black54),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          /// Role + Expiry (Only for logged-in users with valid membership data)
          if (!authController.isGuest && item != null && expiryDate != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/icons/executives.png',
                  height: 2.5.h,
                  width: 2.5.h,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.role,
                        style:  TextStyle(
                          fontSize: 16.sp,
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
                          color: expired ? Colors.red : Colors.green,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          /// Renew Membership button (Only show if user + expired + expiryDate exists)
          if (!authController.isGuest && expired && expiryDate != null) ...[
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xFFDD3D3D),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.5.h,
                  ),
                  child:  Text(
                    "Renew Membership",
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

}
