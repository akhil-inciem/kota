import 'package:flutter/material.dart';
import 'package:kota/model/executive_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:kota/constants/colors.dart';

class ExecutiveCard extends StatelessWidget {
  final LeadersDetail executive;

  const ExecutiveCard({super.key, required this.executive});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Executive Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "https://media.istockphoto.com/id/1399565382/photo/young-happy-mixed-race-businessman-standing-with-his-arms-crossed-working-alone-in-an-office.jpg?s=612x612&w=0&k=20&c=buXwOYjA_tjt2O3-kcSKqkTp2lxKWJJ_Ttx2PhYe3VM=",
            //  Image.asset(
            //   executive.portalImage!,
            width: double.infinity,
            height: 18.h,
            fit: BoxFit.cover,
          ),
        ),

        // Info Section
        Container(
          height: 16.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                executive.designation ?? '',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),

              /// First name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    executive.firstName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    executive.lastName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              /// Last name + share button
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         executive.lastName ?? '',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 15.sp,
              //         ),
              //         maxLines: 1,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ),
              //     IconButton(
              //       icon: Icon(Icons.share, size: 18.sp),
              //       onPressed: () {
              //         // Share functionality here
              //       },
              //     ),
              //   ],
              // ),
              Text(
                executive.officialMobile ?? '',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              Text(
                executive.officialEmail ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
