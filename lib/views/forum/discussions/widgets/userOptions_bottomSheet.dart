import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/views/forum/discussions/widgets/report_dialogs.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserOptionsBottomSheet extends StatelessWidget {
  final String? threadId;
  final String? commentId;
  final String? replyId;
  final String? blockedUserType;
  final String? blockedUserId;
  final String? blockedUserName;
  final String? pollId;

  const UserOptionsBottomSheet({
    Key? key,
    this.blockedUserType,
    this.blockedUserId,
    this.blockedUserName,
    this.threadId,
    this.commentId,
    this.replyId,
    this.pollId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:3.h,horizontal: 15.sp),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.flag_outlined, color: Colors.orange,size: 20.sp,),
            title: Padding(
              padding:  EdgeInsets.symmetric(horizontal:1.w),
              child: Text("Report",style: TextStyle(fontSize: 15.sp),),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.dialog(
                ReportDialog(
                  blockedUserName: blockedUserName!,
                  blockedUserId: blockedUserId!,
                  blockedUsertype: blockedUserType!,
                  pollId: pollId,
                  threadId: threadId ?? "",
                  commentId: commentId ?? "",
                  replyId: replyId ?? "",
                ),
              );
            },
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 1.h),
            child: ListTile(
              leading: Icon(Icons.block, color: Colors.red,size: 20.sp,),
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal:1.w),
                child: Text("Block User",style: TextStyle(fontSize: 15.sp),),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.dialog(
                  BlockDialog(
                    blockedUsertype: blockedUserType!,
                    blockedUserId: blockedUserId!,
                    blockedUserName: blockedUserName!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
