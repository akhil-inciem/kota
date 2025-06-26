import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/model/poll_reaction_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PollResponsesDialog extends StatelessWidget {
  final List<ReactionData> reactions;

  const PollResponsesDialog({super.key, required this.reactions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Responses',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Text(
                      '${reactions.length} Votes',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Divider(color: Colors.grey.shade400),
            // List of reactions
           reactions.isEmpty ? Padding(
             padding:  EdgeInsets.all(18.sp),
             child: Text("No votes yet"),
           ): Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder:
                    (context, index) => Divider(color: Colors.grey.shade400),
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: reactions.length,
                itemBuilder: (context, index) {
                  final reaction = reactions[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:
                                reaction.userPhoto != null &&
                                        reaction.userPhoto!.isNotEmpty
                                    ? DecorationImage(
                                      image: NetworkImage(reaction.userPhoto!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                            color:
                                reaction.userPhoto == null ||
                                        reaction.userPhoto!.isEmpty
                                    ? Color(0xFFE5E7EB)
                                    : null,
                          ),
                          child:
                              reaction.userPhoto == null ||
                                      reaction.userPhoto!.isEmpty
                                  ? Icon(
                                    Icons.person,
                                    color: Color(0xFF9CA3AF),
                                    size: 6.w,
                                  )
                                  : null,
                        ),

                        SizedBox(width: 4.w),

                        // Inside your build method:
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reaction.userName ?? "Unknown User",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _formatReaction(reaction.reaction),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Time
                        Text(
                          _formatTime(reaction.createdAt),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _formatReaction(String? rawReaction) {
    if (rawReaction == null || rawReaction.isEmpty) {
      return "No reaction";
    }

    // Check if it's in JSON array format
    if (rawReaction.trim().startsWith('[') &&
        rawReaction.trim().endsWith(']')) {
      try {
        final parsed = jsonDecode(rawReaction);
        if (parsed is List) {
          return parsed.join(', ');
        }
      } catch (e) {
        // Fallback if parsing fails
      }
    }

    // If it's just a plain text
    return rawReaction;
  }

  String _formatTime(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) {
    return "N/A";
  }

  try {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();

    final isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;

    String timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm';

    if (isToday) {
      return timeStr;
    } else {
      String day = dateTime.day.toString().padLeft(2, '0');
      String monthName = _monthName(dateTime.month);
      String year = dateTime.year.toString();
      return '$day $monthName $year $timeStr';
    }
  } catch (e) {
    return "N/A";
  }
}

String _monthName(int month) {
  const months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month];
}

}
