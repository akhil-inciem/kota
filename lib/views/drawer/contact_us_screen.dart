import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactUsScreen extends StatelessWidget {
  final contactPhone = '9746302444';
  final contactEmail = 'keralaot@gmail.com';
  final address =
      '43/1508 A, Pipeline Road, Kesaveeyam, Palarivattom, Kochi, Kerala 682025';

  final contacts = [
    {'role': 'PRESIDENT', 'name': 'MARY PHILIP', 'phone': '+91 9744992215'},
    {'role': 'SECRETARY', 'name': 'SMRUTHY JOSE', 'phone': '+91 9488238561'},
    {'role': 'TREASURER', 'name': 'SILLA GEORGE', 'phone': '+91 9972368760'},
  ];

  // void _callNumber(String number) async {
  //   final uri = Uri.parse('tel:$number');
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   }
  // }

  // void _sendEmail(String email) async {
  //   final uri = Uri.parse('mailto:$email');
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        body: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              SizedBox(height: 3.h),

              // Intro Text
              Text(
                'Need assistance? Reach out to our experts.',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 3.h),

              // Main Contact Info
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 3.5.h,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.phone, color: AppColors.primaryButton, size: 3.h),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // _callNumber(contactPhone);
                            },
                            child: Text(
                              contactPhone,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 0.8.h),
                          GestureDetector(
                            onTap: () {
                              // _sendEmail(contactEmail);
                            },
                            child: Text(
                              contactEmail,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
              Text(
                address,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),

              SizedBox(height: 3.h),

              Text(
                "Executive Contacts",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 2.h),

              // List of Contacts
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 4.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.w),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(Icons.person, color: AppColors.primaryButton),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact['name']!,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  contact['role']!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  contact['phone']!,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.call,
                              color: AppColors.primaryButton,
                              size: 3.h,
                            ),
                            onPressed: () {
                              // _callNumber(contact['phone']!);
                            },
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

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, size: 3.h),
        ),
        SizedBox(width: 4.w),
        Text(
          "Contact Us",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
