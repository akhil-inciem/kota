import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PollList extends StatefulWidget {
  final List<Map<String, dynamic>> polls;
  final Map<int, Set<int>> selectedAnswers;
  final void Function(int, int, bool) onOptionToggle;

  const PollList({
    super.key,
    required this.polls,
    required this.selectedAnswers,
    required this.onOptionToggle,
  });

  @override
  State<PollList> createState() => _PollListState();
}

class _PollListState extends State<PollList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.polls.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
      itemBuilder: (context, index) => PollCard(
        poll: widget.polls[index],
        pollIndex: index,
        selectedOptions: widget.selectedAnswers[index] ?? {},
        onToggle: widget.onOptionToggle,
      ),
    );
  }
}


class PollCard extends StatelessWidget {
  final Map<String, dynamic> poll;
  final int pollIndex;
  final Set<int> selectedOptions;
  final void Function(int pollIndex, int optionIndex, bool isMultiple) onToggle;

  const PollCard({
    super.key,
    required this.poll,
    required this.pollIndex,
    required this.selectedOptions,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final options = poll['options'] as List<Map<String, dynamic>>;
    final isMultiple = poll['multiple'] ?? false;
    final totalVotes = options.fold<int>(0, (sum, o) => sum + (o['votes'] as int));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time and Edit Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                poll["createdAt"],
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (poll["isEditable"])
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.mode_edit_outlined, size: 20.sp),
                ),
            ],
          ),
          SizedBox(height: 1.h),

          // Question
          Text(
            poll["question"],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 1.h),

          // Options
          ...List.generate(options.length, (i) {
            final percent = totalVotes == 0 ? 0.0 : (options[i]["votes"] as int) / totalVotes;
            final isSelected = selectedOptions.contains(i);

            return InkWell(
              onTap: () => onToggle(pollIndex, i, isMultiple),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Row(
                  children: [
                    Icon(
                      isMultiple
                          ? (isSelected ? Icons.check_box : Icons.check_box_outline_blank)
                          : (isSelected ? Icons.radio_button_checked : Icons.radio_button_off),
                      size: 20.sp,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(options[i]["text"]),
                          SizedBox(height: 0.5.h),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: percent,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryText,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(options[i]["votes"].toString()),
                  ],
                ),
              ),
            );
          }),

          SizedBox(height: 2.h),

          // View Votes Button
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                // Handle view votes tap here
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "View Votes",
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
