import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class ChangePasswordWidget extends StatelessWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.key),
            SizedBox(width: 5.w),
            const Text('Change Password'),
            Spacer(),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
