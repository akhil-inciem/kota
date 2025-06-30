import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/model/poll_model.dart';
import 'package:kota/views/forum/polls/widgets/poll_response_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

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
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: PollShimmer());
      }

      final items = controller.filteredPolls.value; // ✅ access .value

      return ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          final poll = items[index];
          // final fullIndex = controller.pollsList.indexWhere((e) => e.id == poll.id);
          // final selected = controller.selectedPollAnswers[fullIndex] ?? {};
          return Obx(() {
              return PollCard(
                poll: poll,
                pollIndex: index, // Optional now
                selectedOptions: controller.selectedPollAnswers[poll.id] ?? {},
                onToggle: controller.togglePollOption,
              );
            }
          );

        },
      );
    });
  }
}


class PollCard extends StatelessWidget {
  final PollData poll;
  final int pollIndex;
  final Set<int> selectedOptions;
  final void Function(String pollIndex, int optionIndex, bool isMultiple) onToggle;

  PollCard({
    super.key,
    required this.poll,
    required this.pollIndex,
    required this.selectedOptions,
    required this.onToggle,
  });

  final ForumController forumController = Get.find<ForumController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final options = _parseOptions(poll.pollFeild ?? '');
    final votes = _parseVotes(options);
    final isMultiple = poll.allowmultiple?.toLowerCase() == '1';
    final adjustedVotesList = _getAdjustedVotes(votes);
    final adjustedTotalVotes = adjustedVotesList.fold<int>(
      0,
      (sum, v) => sum + v,
    );

    final isExpired = poll.expired == true; // 👈 Check expiry

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          // Show expired message
          if (isExpired)
            const Text(
              "This poll has expired",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400),
            ),
          if (isExpired) const SizedBox(height: 8),
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
              isExpired: isExpired, // 👈 pass to row
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
    final raw = poll.reactionCounts[opt]; // directly access the map
    print("Option: $opt => Votes: $raw");
    return raw?.toString() ?? '0'; // fallback to '0' if null
  }).toList();
}


  List<int> _getAdjustedVotes(List<String> votes) {
    return List.generate(votes.length, (i) {
      final originalVotes = int.tryParse(votes[i]) ?? 0;
      return originalVotes;
    });
  }

  Widget _buildHeader() {
    String displayTime = _formatTime(poll.createdAt.toString());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          displayTime,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        authController.userModel.value?.data.id == poll.createdBy &&
poll.editable! &&
selectedOptions.isEmpty

            ? GestureDetector(
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
            )
            : const SizedBox.shrink(),
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
    required bool isExpired, // 👈 add param
  }) {
    return InkWell(
      onTap:
          isExpired
              ? null
              : () => onToggle(poll.id!, index, isMultiple), // 👈 disable if expired
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              (isSelected ? Icons.check_circle : Icons.radio_button_off),
              size: 20,
              color: isExpired ? Colors.grey : null, // dim icon if expired
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    optionText,
                    style: TextStyle(
                      color: isExpired ? Colors.grey : Colors.black, // dim text
                    ),
                  ),
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

  bool _isLoadingVotes = false;

  Widget _buildViewVotesButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          if (_isLoadingVotes) return; // Block rapid clicks

          _isLoadingVotes = true;
          try {
            await forumController.loadPollReactions(poll.id ?? "0");
            if (Get.context != null) {
              await showDialog(
                context: Get.context!,
                builder: (context) {
                  return PollResponsesDialog(
                    reactions: forumController.pollReactionList,
                  );
                },
              );
            }
          } catch (e) {
            // Optionally show a snackbar or log error
            print("Error loading poll reactions: $e");
          } finally {
            _isLoadingVotes = false;
          }
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


  String _formatTime(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '';

    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();
      final diff = now.difference(createdDate);

      if (diff.inMinutes < 1) {
        return 'Just now';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} minutes ago';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} hours ago';
      } else {
        return DateFormat('dd MMMM yyyy hh:mma').format(createdDate);
      }
    } catch (e) {
      return '';
    }
  }
}
class PollShimmer extends StatelessWidget {
  final int itemCount;

  const PollShimmer({Key? key, this.itemCount = 7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      itemCount: itemCount,
      itemBuilder: (_, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.w,
                  height: 14,
                  color: Colors.white,
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  height: 1.5.h,
                  color: Colors.white,
                ),
                SizedBox(height: 2.h),
                Container(
                  width: 80.w,
                  height: 1.5.h,
                  color: Colors.white,
                ),
                SizedBox(height: 2.h,),
                Align(alignment: Alignment.centerRight,child: Container(height: 3.h,width: 20.w,color: Colors.white,)),
                SizedBox(height: 1.h),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}