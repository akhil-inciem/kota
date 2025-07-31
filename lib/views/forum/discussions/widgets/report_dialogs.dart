import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BlockDialog extends StatelessWidget {
  final String blockedUsertype;
  final String blockedUserId;
  final String blockedUserName;
  final String? userAvatar;

  const BlockDialog({
    Key? key,
    required this.blockedUsertype,
    required this.blockedUserId,
    required this.blockedUserName,
    this.userAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final controller = Get.find<ForumController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.sp)),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.block, size: 8.w, color: Colors.red.shade600),
            ),

            SizedBox(height: 2.h),

            // Title
            Text(
              "Block User",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),

            SizedBox(height: 1.h),

            // Avatar
            if (userAvatar != null) ...[
              CircleAvatar(
                radius: 5.w,
                backgroundImage: NetworkImage(userAvatar!),
              ),
              SizedBox(height: 1.h),
            ],

            // Confirmation Text
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 16.sp,
                ),
                children: [
                  const TextSpan(text: "Are you sure you want to block "),
                  TextSpan(
                    text: blockedUserName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 16.sp,
                    ),
                  ),
                  const TextSpan(
                    text:
                        "?\n\nThey won't be able to message you or see your profile.",
                  ),
                ],
              ),
            ),

            SizedBox(height: 3.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.sp),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: CustomButton(
                    height: 5.h,
                    onPressed: () async {
                      await controller.blockUser(
                        blockedUserId: blockedUserId,
                        blockedUserType: blockedUsertype,
                        userId: authController.userModel.value!.data.id,
                        userType: authController.userModel.value!.data.isGuest ? "guest" : "member",
                      );
                      Get.back();
                      CustomSnackbars.success(
                        "$blockedUserName has been blocked",
                        "Blocked",
                      );
                    },
                    text: "Block",
                    backgroundColor: Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDialog extends StatelessWidget {
  final String blockedUsertype;
  final String blockedUserId;
  final String blockedUserName;
  final String? userAvatar;
  final String? threadId;
  final String? pollId;
  final String? commentId;
  final String? replyId;

   ReportDialog({
    Key? key,
    this.userAvatar,
    this.threadId,
    this.commentId,
    this.pollId,
    this.replyId,
    required this.blockedUsertype,
    required this.blockedUserId,
    required this.blockedUserName,
  }) : super(key: key);

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForumController>(
      init: ForumController(),
      builder: (controller) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Container(
            padding: EdgeInsets.all(4.w),
            constraints: BoxConstraints(maxHeight: 80.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              color: Theme.of(context).dialogBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                SizedBox(height: 2.h),
                _buildUserInfo(context),
                SizedBox(height: 2.h),
                _buildIssueLabel(),
                SizedBox(height: 1.h),
                _buildReasonsList(context, controller),
                if (controller.selectedReason == "Other") ...[
                  SizedBox(height: 2.h),
                  _buildAdditionalDetails(context, controller),
                ],
                SizedBox(height: 2.h),
                _buildActions(context, controller),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.flag_outlined,
            size: 5.w,
            color: Colors.orange.shade600,
          ),
        ),
        SizedBox(width: 3.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Report User",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "Help us understand what's happening",
              style: TextStyle(fontSize: 13.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 4.w,
            backgroundImage:
                userAvatar != null ? NetworkImage(userAvatar!) : null,
            child:
                userAvatar == null
                    ? Text(blockedUserName[0].toUpperCase())
                    : null,
          ),
          SizedBox(width: 3.w),
          Text(
            blockedUserName,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueLabel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "What's the issue?",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
      ),
    );
  }

  Widget _buildReasonsList(BuildContext context, ForumController controller) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children:
              controller.reasons.map((reason) {
                final selected = controller.selectedReason == reason.title;
                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: InkWell(
                    onTap: () => controller.selectReason(reason.title),
                    borderRadius: BorderRadius.circular(2.w),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              selected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(2.w),
                        color:
                            selected
                                ? Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.05)
                                : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            reason.icon,
                            size: 5.w,
                            color:
                                selected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reason.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color:
                                        selected
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                  ),
                                ),
                                Text(
                                  reason.subtitle,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Radio<String>(
                            value: reason.title,
                            groupValue: controller.selectedReason,
                            onChanged: (val) => controller.selectReason(val!),
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildAdditionalDetails(
    BuildContext context,
    ForumController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Additional details (optional)",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: controller.detailsController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Provide more context...",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.w),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: EdgeInsets.all(3.w),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, ForumController controller) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: controller.isReportSubmitting ? null : () => Get.back(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.w),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: CustomButton(
            height: 5.h,
            isEnabled: !controller.isReportSubmitting,
            onPressed:
                controller.selectedReason.isEmpty
                    ? null
                    : () async {
                      await controller.flagUser(
                        blockedUserId: blockedUserId,
                        blockedUsertype: blockedUsertype,
                        userId: authController.userModel.value!.data.id,
                        userType: authController.userModel.value!.data.isGuest ? "guest" : "member",
                        pollId: pollId ?? "",
                        threadId: threadId ?? '',
                        commentId: commentId ?? '',
                        replyId: replyId ?? '',
                        reason: controller.selectedReason,
                        additionalDetails:
                            controller.detailsController.text.trim(),
                      );
                      Get.back();
                      CustomSnackbars.success("User has been flagged for review","Reported");
                    },
            text: "Submit Report",
          ),
        ),
      ],
    );
  }
}
