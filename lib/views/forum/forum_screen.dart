import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/add_discussion_page.dart';
import 'package:kota/views/forum/widgets/forumlist.dart';
import 'package:kota/views/home/widgets/news_list.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final ForumController forumController = Get.put(ForumController());

  @override
  void initState() {
    super.initState();
    forumController.loadThreads();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        SizedBox(height: 0.5.h),
        CustomSearchBar(
          controller: forumController.searchController,
          onChanged: (value) => forumController.setSearchQuery(value),
        ),
        SizedBox(height: 2.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 6.w,right: 6.w, top: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Discussions",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 6.w,
                                    height: 2.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xFF0A57C9),
                                    ),
                                    child: Center(
                                      child: Obx(() {
                                          return Text(
                                            forumController.threadsList.length.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomButton(
                                width: 25.w,
                                height: 4.h,
                                text: 'New',
                                icon: Icon(Icons.add, color: Colors.white),
                                backgroundColor: AppColors.primaryButton,
                                textColor: Colors.white,
                                onPressed: ()=>Get.to(()=> NewDiscussionPage()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          height: 1,
                        ),
                        SizedBox(height:70.h,child: ForumList()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
