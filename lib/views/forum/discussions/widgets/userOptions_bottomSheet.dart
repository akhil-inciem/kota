import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/views/forum/discussions/widgets/report_dialogs.dart';

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
    this.pollId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.flag_outlined, color: Colors.orange),
            title: Text("Report"),
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
          ListTile(
            leading: Icon(Icons.block, color: Colors.red),
            title: Text("Block User"),
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
        ],
      ),
    );
  }
}
