import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final contactPhone = '+91 9746302444';
  final contactEmail = 'keralaot@gmail.com';
  final address =
      '43/1508 A, Pipeline Road, Kesaveeyam, Palarivattom, Kochi, Kerala 682025';

  final contacts = [
    {'role': 'PRESIDENT', 'name': 'MARY PHILIP', 'phone': '+91 9744992215'},
    {'role': 'SECRETARY', 'name': 'SMRUTHY JOSE', 'phone': '+91 9488238561'},
    {'role': 'TREASURER', 'name': 'SILLA GEORGE', 'phone': '+91 9972368760'},
  ];

  void _callNumber(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // You can show a toast or dialog here
      debugPrint('Could not launch email client');
    }
  }

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
                'Need assistance? Reach out to our experts',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Color(0xFF0A2C49)),
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
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _callNumber(contactPhone);
                          },
                          child: CircleAvatar(
                            radius: 3.5.h,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.phone,
                              color: AppColors.primaryColor,
                              size: 3.h,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contactPhone,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.8.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // _sendEmail(contactEmail);
                                      },
                                      child: Text(
                                        contactEmail,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.primaryText,
                                          fontWeight: FontWeight.w500,
                                          // decoration: TextDecoration.underline, // Underline to indicate it's clickable
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    SizedBox(height: 1.h),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),
              Text(
                "Executive Contacts",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
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
                            child: Icon(
                              Icons.person,
                              color: AppColors.primaryColor,
                            ),
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
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0A2C49)
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  contact['role']!.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  contact['phone']!,
                                  style: TextStyle(fontSize: 15.sp),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.call,
                              color: AppColors.primaryColor,
                              size: 3.h,
                            ),
                            onPressed: () {
                              _callNumber(contact['phone']!);
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
          child:  Image.asset(
                      'assets/icons/backbutton.png',
                      // color: Colors.black,
                      width: 6.w,
                      height: 2.5.h,
                      fit: BoxFit.contain,
                    ),
        ),
        SizedBox(width: 4.w),
        Text(
          "Contact Us",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Color(0xFF0A2C49)),
        ),
      ],
    );
  }
}
