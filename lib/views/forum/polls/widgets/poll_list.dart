import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/model/poll_model.dart';
import 'package:kota/views/forum/polls/widgets/poll_response_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../add_poll_screen.dart';

class PollList extends StatefulWidget {
  const PollList({super.key});

  @override
  State<PollList> createState() => _PollListState();
}

class _PollListState extends State<PollList> {
  final controller = Get.put(ForumController());

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: controller.pollsList.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
      itemBuilder:
          (context, index) => Obx(() {
            return PollCard(
              poll: controller.pollsList[index],
              pollIndex: index,
              selectedOptions: controller.selectedPollAnswers[index] ?? {},
              onToggle: controller.togglePollOption,
            );
          }),
    );
  }
}

class PollCard extends StatelessWidget {
  final PollData poll;
  final int pollIndex;
  final Set<int> selectedOptions;
  final void Function(int pollIndex, int optionIndex, bool isMultiple) onToggle;

  PollCard({
    super.key,
    required this.poll,
    required this.pollIndex,
    required this.selectedOptions,
    required this.onToggle,
  });

  final ForumController forumController = Get.find<ForumController>();

  @override
  Widget build(BuildContext context) {
    final options = _parseOptions(poll.pollFeild ?? '');
    final votes = _parseVotes(options);
    final isMultiple = poll.allowmultiple?.toLowerCase() == 'true';
    final adjustedVotesList = _getAdjustedVotes(votes);
    final adjustedTotalVotes = adjustedVotesList.fold<int>(
      0,
      (sum, v) => sum + v,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          Text(
            poll.title ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(options.length, (i) {
            final adjustedOptionVotes = adjustedVotesList[i];
            final percent =
                adjustedTotalVotes == 0
                    ? 0.0
                    : adjustedOptionVotes / adjustedTotalVotes;

            return _buildOptionRow(
              optionText: options[i],
              index: i,
              isMultiple: isMultiple,
              isSelected: selectedOptions.contains(i),
              adjustedOptionVotes: adjustedOptionVotes,
              percent: percent,
            );
          }),
          const SizedBox(height: 16),
          _buildViewVotesButton(),
        ],
      ),
    );
  }

  List<String> _parseOptions(String pollFeild) {
    try {
      final decoded = jsonDecode(pollFeild);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // Fallback
    }
    return pollFeild.split(',').map((e) => e.trim()).toList();
  }

  List<String> _parseVotes(List<String> options) {
    return options.map((opt) {
      final raw = poll.reactionCounts?.toJson()[opt]?.toString();
      return raw ?? '0';
    }).toList();
  }

  List<int> _getAdjustedVotes(List<String> votes) {
    return List.generate(votes.length, (i) {
      final originalVotes = int.tryParse(votes[i]) ?? 0;
      return selectedOptions.contains(i) ? originalVotes + 1 : originalVotes;
    });
  }

  Widget _buildHeader() {
    // Extract time portion if possible
    String timeText = '';
    if ((poll.createdAt ?? '').contains(' ')) {
      timeText = (poll.createdAt ?? '').split(' ').last;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          timeText,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        poll.editable! ? GestureDetector(
          onTap: () {
            Get.to(() => NewPollPage(pollToEdit: poll));
          },
          child: Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              color: AppColors.primaryBackground,
            ),
            child: const Icon(Icons.edit_outlined),
          ),
        ) : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildOptionRow({
    required String optionText,
    required int index,
    required bool isMultiple,
    required bool isSelected,
    required int adjustedOptionVotes,
    required double percent,
  }) {
    return InkWell(
      onTap: () => onToggle(pollIndex, index, isMultiple),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              isMultiple
                  ? (isSelected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank)
                  : (isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(optionText),
                  const SizedBox(height: 4),
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
            const SizedBox(width: 8),
            Text(adjustedOptionVotes.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildViewVotesButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          await forumController.loadPollReactions(poll.id ?? "0");
          showDialog(
            context: Get.context!,
            builder: (context) {
              return PollResponsesDialog(
                reactions: forumController.pollReactionList,
              );
            },
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "View Votes",
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
