import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/model/poll_reaction_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PollResponsesDialog extends StatelessWidget {
  final List<ReactionData> reactions;
  final int totalVotes;

  const PollResponsesDialog({
    super.key,
    required this.reactions,
    required this.totalVotes,
  });

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
                      '$totalVotes ${totalVotes == 1 ? "Vote" : "Votes"}',
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
                      padding: EdgeInsets.all(1.5.w),
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
            reactions.isEmpty
                ? Padding(
                  padding: EdgeInsets.all(18.sp),
                  child: Text("No votes yet"),
                )
                : Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder:
                        (context, index) =>
                            Divider(color: Colors.grey.shade400),
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
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // updated
                          children: [
                            // Profile Picture
                            Container(
  width: 12.w,
  height: 12.w,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: (reaction.userPhoto == null || reaction.userPhoto!.isEmpty)
        ? const Color(0xFFE5E7EB)
        : null,
  ),
  child: ClipOval(
    child: reaction.userPhoto != null && reaction.userPhoto!.isNotEmpty
        ? Image.network(
            reaction.userPhoto!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: SizedBox(
                  width: 24, // or any size suitable
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person,
                color: const Color(0xFF9CA3AF),
                size: 6.w,
              );
            },
          )
        : Center(
            child: Icon(
              Icons.person,
              color: const Color(0xFF9CA3AF),
              size: 6.w,
            ),
          ),
  ),
),

                            SizedBox(width: 4.w),

                            // Name and description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reaction.userName ?? "Unknown User",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0A2C49),
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  ..._parseReaction(reaction.reaction).map(
                                    (r) => Padding(
                                      padding: EdgeInsets.only(bottom: 0.3.h),
                                      child: Text(
                                        "• $r",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Time aligned with description
                            Column(
                              children: [
                                SizedBox(
                                  height: 22.sp,
                                ), // aligns with description
                                Text(
                                  _formatTime(reaction.createdAt),
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
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

  List<String> _parseReaction(String? rawReaction) {
    if (rawReaction == null || rawReaction.isEmpty) {
      return ["No reaction"];
    }

    if (rawReaction.trim().startsWith('[') &&
        rawReaction.trim().endsWith(']')) {
      try {
        final parsed = jsonDecode(rawReaction);
        if (parsed is List) {
          return parsed.map((e) => e.toString()).toList();
        }
      } catch (e) {
        // Fall through to single item fallback
      }
    }

    // Fallback: treat whole input as one item
    return [rawReaction];
  }

  String _formatTime(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return "N/A";
    }

    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();

      final isToday =
          dateTime.year == now.year &&
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
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}
