import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/forum/widgets/add_imageSection.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewDiscussionPage extends StatefulWidget {
  const NewDiscussionPage({super.key});

  @override
  State<NewDiscussionPage> createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {
  final ForumController _forumController = Get.find<ForumController>();

  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    userController.loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (userController.user.value == null) {
            return const Center(child: Text('No user data found'));
          } else {
            final user = userController.user.value!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TopBar(
                      title: "New Discussion",
                      leadingIcon: "assets/icons/close.png",
                      onTap: () => Get.back(),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            user.photo?.isNotEmpty == true
                                ? user.photo!
                                : 'https://ui-avatars.com/api/?name=${user.firstName}+${user.lastName}&background=random&color=fff',
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          '${user.firstName} ${user.lastName}',
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

                  /// Title TextField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: TextField(
                      autofocus: false,
                      controller: _forumController.titleController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                        hintStyle: TextStyle(fontSize: 16),
                        border: InputBorder.none,
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
                    ),
                  ),

                  /// Description TextField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.w),
                    child: TextField(
                      autofocus: false,
                      maxLines: 10,
                      controller: _forumController.descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Type your question/queries here...',
                        hintStyle: TextStyle(fontSize: 16),
                        border: InputBorder.none,
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(8),
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),

                  Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
                  SizedBox(height: 2.h),
                  AddImageSection(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: CustomButton(
                      text: "Create Discussion",
                      backgroundColor: AppColors.primaryButton,
                      textColor: Colors.white,
                      onPressed: _forumController.createDiscussion,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
