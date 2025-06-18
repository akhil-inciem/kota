import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/forum/add_discussion_page.dart';
import 'package:kota/views/forum/widgets/poll_list.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForumPollTab extends StatelessWidget {
  const ForumPollTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForumController>();
    controller.polls.value = [
      {
        "createdAt": "10 hours ago",
        "question": "How Often Do You Modify Treatment Plans Mid-Cycle?",
        "options": [
          {"text": "Weekly", "votes": 2},
          {"text": "Biweekly", "votes": 1},
          {"text": "Only if progress plateaus", "votes": 6},
          {"text": "Entirely on the client population", "votes": 9},
        ],
        "isEditable": true,
      },
      {
        "createdAt": "12 June 2025 | 05:42 PM",
        "question": "How Often Do You Modify Treatment Plans Mid-Cycle?",
        "options": [
          {"text": "Weekly", "votes": 2},
          {"text": "Biweekly", "votes": 1},
        ],
        "isEditable": true,
      },
    ];

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
                      backgroundColor: AppColors.primaryButton,
                      textColor: Colors.white,
                      onPressed: () => Get.to(() => const NewDiscussionPage()),
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
                polls: controller.polls,
                selectedAnswers: controller.selectedPollAnswers,
                onOptionToggle: controller.togglePollOption,
              ),
            ),
            ],
          ),
        );
  }
}