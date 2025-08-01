import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/forum_controller.dart';
import 'package:kota/model/poll_model.dart';
import 'package:kota/views/forum/discussions/widgets/userOptions_bottomSheet.dart';
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

      if (items.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadPolls(); // Replace with your actual method
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 20.h), // add space to allow pull
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/forum_unselected.png',
                      height: 8.h,
                      width: 8.h,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No Polls Available",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.loadPolls(); // Replace with your actual method
        },
        child: ListView.separated(
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
            });
          },
        ),
      );
    });
  }
}

class PollCard extends StatelessWidget {
  final PollData poll;
  final int pollIndex;
  final Set<int> selectedOptions;
  final void Function(String pollIndex, int optionIndex, bool isMultiple)
  onToggle;

  PollCard({
    super.key,
    required this.poll,
    required this.pollIndex,
    required this.selectedOptions,
    required this.onToggle,
  });

  final ForumController forumController = Get.find<ForumController>();
  final authController = Get.find<AuthController>();

  final bool _isLoadingVotes = false;

  @override
  Widget build(BuildContext context) {
    final userId = authController.userModel.value!.data.id;
    final options = _parseOptions(poll.pollFeild ?? '');
    final votes = _parseVotes(options);
    final isMultiple = poll.allowmultiple?.toLowerCase() == '1';
    final adjustedVotesList = _getAdjustedVotes(votes);
    final adjustedTotalVotes = adjustedVotesList.fold<int>(
      0,
      (sum, v) => sum + v,
    );
    final isExpired = poll.expired == true;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 1.h),
          if (isExpired)
            Text(
              "This poll has expired",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
              ),
            ),
          if (isExpired) SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // Text(
                    //   poll.creatorName ?? "",
                    //   maxLines: 2,
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.normal,
                    //     fontSize: 14.sp,
                    //     fontStyle: FontStyle.italic,
                    //     color: Colors.black,
                        
                    //   ),
                    // ),
                    // SizedBox(height: 1.h),
                    Text(
                      poll.title ?? "",
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.black,
                        
                      ),
                    ),
                  ],
                ),
              ),
              poll.createdBy == userId ? SizedBox.shrink() : IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder:
                        (_) => UserOptionsBottomSheet(
                          blockedUserType: "member",
                          blockedUserId: poll.createdBy ?? "",
                          blockedUserName: poll.creatorName ?? "",
                          pollId: poll.id,
                        ),
                  );
                },
                icon: Icon(Icons.more_horiz_outlined,size: 20.sp,),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          ...List.generate(options.length, (i) {
            final percent =
                adjustedTotalVotes == 0
                    ? 0.0
                    : adjustedVotesList[i] / adjustedTotalVotes;
            return _buildOptionRow(
              optionText: options[i],
              index: i,
              isMultiple: isMultiple,
              isSelected: selectedOptions.contains(i),
              adjustedOptionVotes: adjustedVotesList[i],
              percent: percent,
              isExpired: isExpired,
            );
          }),
          SizedBox(height: 2.h),
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
    } catch (_) {}
    return pollFeild.split(',').map((e) => e.trim()).toList();
  }

  List<String> _parseVotes(List<String> options) {
    return options
        .map((opt) => poll.reactionCounts[opt]?.toString() ?? '0')
        .toList();
  }

  List<int> _getAdjustedVotes(List<String> votes) {
    return votes.map((v) => int.tryParse(v) ?? 0).toList();
  }

  Widget _buildHeader() {
    final displayTime = _formatTime(poll.createdAt.toString());
    final canEdit =
        authController.userModel.value?.data.id == poll.createdBy &&
        poll.editable! &&
        selectedOptions.isEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          displayTime,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
            fontSize: 14.sp,
          ),
        ),
        canEdit
            ? GestureDetector(
              onTap: () => Get.to(() => NewPollPage(pollToEdit: poll)),
              child: Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.sp),
                  color: AppColors.primaryBackground,
                ),
                child: Icon(Icons.edit_outlined, size: 20.sp),
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
    required bool isExpired,
  }) {
    return InkWell(
      onTap: isExpired ? null : () => onToggle(poll.id!, index, isMultiple),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_off,
              size: 18.sp,
              color: isExpired ? Colors.grey : AppColors.primaryColor,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(
                            color: isExpired ? Colors.grey : Colors.black,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                      Text(
                        '$adjustedOptionVotes',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Stack(
                    children: [
                      Container(
                        height: 1.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          height: 1.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryText,
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
          if (_isLoadingVotes) return;

          try {
            await forumController.loadPollReactions(poll.id ?? "0");
            if (Get.context != null) {
              await showDialog(
                context: Get.context!,
                builder:
                    (_) => PollResponsesDialog(
                      reactions: forumController.pollReactionList,
                      totalVotes: forumController.totalVotes.value,
                    ),
              );
            }
          } catch (e) {
            print("Error loading poll reactions: $e");
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "View Votes",
            style: TextStyle(
              fontSize: 15.sp,
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

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
      if (diff.inHours < 24) return '${diff.inHours} hours ago';

      return DateFormat('dd MMM yyyy | hh:mm a').format(createdDate);
    } catch (_) {
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
                Container(width: 50.w, height: 14, color: Colors.white),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  height: 1.5.h,
                  color: Colors.white,
                ),
                SizedBox(height: 2.h),
                Container(width: 80.w, height: 1.5.h, color: Colors.white),
                SizedBox(height: 2.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 3.h,
                    width: 20.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1.h),
                Divider(color: Colors.grey.shade300, thickness: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}
