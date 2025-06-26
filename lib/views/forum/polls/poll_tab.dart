import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/discussions/add_discussion_page.dart';
import 'package:kota/views/forum/polls/add_poll_screen.dart';
import 'package:kota/views/forum/polls/widgets/poll_list.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumPollTab extends StatefulWidget {
  const ForumPollTab({Key? key}) : super(key: key);

  @override
  State<ForumPollTab> createState() => _ForumPollTabState();
}

class _ForumPollTabState extends State<ForumPollTab> {
  final controller = Get.find<ForumController>();

  @override
  void initState() {
    super.initState();
     controller.loadPolls();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    CustomButton(
                      width: 25.w,
                      height: 4.h,
                      text: 'New',
                      icon: const Icon(Icons.add, color: Colors.white),
                      backgroundColor: AppColors.primaryColor,
                      textColor: Colors.white,
                      onPressed: () => Get.to(() => const NewPollPage()),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
            thickness: 1,
              ),
              Expanded(
              child: PollList(
              ),
            ),
            ],
          ),
        );
  }
}