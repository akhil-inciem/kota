import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/forum/widgets/add_imageSection.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewDiscussionPage extends StatelessWidget {
  const NewDiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h,),
              TopBar(title: "New Discussion",leadingIcon: "assets/icons/close.png",onTap: ()=>Get.back(),),
              SizedBox(height: 2.h,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          'John Alexander',
                          style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                          ),
                        ),
                      ],
                    ),
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // border: Border(
                    //   left: BorderSide(color: Colors.blue, width: 2),
                    // ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: TextField(
                    maxLines: 13,
                    decoration: InputDecoration(
                      hintText: 'Type your question/ queries here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            height: 1,
          ),
          SizedBox(height: 2.h,),
          AddImageSection(),
            ],
          ),
        ),
      ),
    );
  }
}