import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExecutivePage extends StatelessWidget {
  const ExecutivePage({super.key});

  final List<Map<String, String>> executives = const [
    {
      "name": "Dr. Alice Smith",
      "phone": "+1 234 567 890",
      "email": "alice.smith@example.com",
      "image": "assets/images/certificate.jpg",
    },
    {
      "name": "Dr. Bob Johnson",
      "phone": "+1 987 654 321",
      "email": "bob.johnson@example.com",
      "image": "assets/images/recommend_tile.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar-like Row
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/icons/backbutton.png',
                      color: Colors.black,
                      width: 6.w,
                      height: 2.5.h,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "KOTA Executives",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Grid
              Expanded(
                child: GridView.builder(
                  itemCount: executives.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.h,
                    crossAxisSpacing: 4.w,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final executive = executives[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              executive["image"]!,
                              width: double.infinity,
                              height: 18.h,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name and share button row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        executive["name"]!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.share, size: 18.sp),
                                      onPressed: () {
                                        // TODO: Implement share logic
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  executive["phone"]!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  executive["email"]!,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
