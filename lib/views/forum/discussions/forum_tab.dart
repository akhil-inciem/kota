import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/discussions/add_discussion_page.dart';
import 'package:kota/views/forum/discussions/widgets/forumlist.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumDiscussionTab extends StatelessWidget {
  const ForumDiscussionTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forumController = Get.find<ForumController>();
    final AuthController authController = Get.find<AuthController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                authController.isGuest
                    ? Row(
                      children: [
                        const Text(
                          "Discussions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 8.w,
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFF0A57C9),
                          ),
                          child: Center(
                            child: Obx(() {
                              return Text(
                                forumController.threadsList.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    )
                    : const SizedBox.shrink(), // Nothing on left if not guest

                CustomButton(
                  width: 25.w,
                  height: 4.h,
                  text: 'New',
                  icon: const Icon(Icons.add, color: Colors.white),
                  backgroundColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () => Get.to(() => const NewDiscussionPage()),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
          Expanded(child: ForumList()),
        ],
      ),
    );
  }
}
