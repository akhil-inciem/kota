import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/discussion_api_services.dart';
import 'package:kota/apiServices/report_api_services.dart';
import 'package:kota/model/forum_model.dart';
import 'package:kota/model/poll_model.dart';
import 'package:kota/model/poll_reaction_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';

import '../apiServices/poll_api_services.dart';

class ForumController extends GetxController {
  final isLoading = true.obs;
  final isThreadLoading = false.obs;
  final isPollLoading = true.obs;
  final RxBool isCropping = false.obs;
  final selectedImages = <XFile>[].obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RxString selectedThreadId = ''.obs;
  final forumModel = Rxn<ForumModel>();
  final threadsList = <ForumData>[].obs;
  final originalThreadsList = <ForumData>[];
  final RxBool isButtonEnabled = false.obs;
  final RxBool isSubmitting = false.obs;
  final isPosting = false.obs;
  final hasText = false.obs;
  var comments = <Comments>[].obs;
  final Rxn<ForumData> singleThread = Rxn<ForumData>();
  final RxInt selectedTabIndex = 0.obs;
  final ForumApiService _forumApiService = ForumApiService();
  final PollApiService _pollApiService = PollApiService();
  final ReportApiServices _reportApiServices = ReportApiServices();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final isReplying = false.obs;
  final replyingToId = ''.obs;
  final searchQuery = ''.obs;
  final commentText = ''.obs;
  var isLiked = false.obs;
  var likeCount = '0'.obs;
  var commentCount = '0'.obs;
  var hasInsertedMention = false.obs;
  final FocusNode commentFocusNode = FocusNode();
  RxString replyingToName = ''.obs; // Optional: To show UI hint

  //polls
  final pollTitleController = TextEditingController();
  final pollDescriptionController = TextEditingController();
  final pollFields = <TextEditingController>[].obs;
  final isCreatePollEnabled = false.obs;
  final isPollReactionsLoading = false.obs;
  final allowMultiple = false.obs;
  final pollReactionList = <ReactionData>[];
  final allowMultipleSwitchController = ValueNotifier<bool>(false);
  final pollsList = <PollData>[].obs;
  final filteredPolls = <PollData>[].obs;
  final selectedPollAnswers = <String, Set<int>>{}.obs; // key = poll.id
  RxInt totalVotes = 0.obs;
  final Rx<DateTime?> pollExpiryDate = Rx<DateTime?>(null);
  final pollSearchQuery = ''.obs;
  final Map<String, Set<int>> userSelectedOptionsCache = {};

  @override
  void onInit() {
    super.onInit();
    loadPolls();
    commentController.addListener(() {
      commentText.value = commentController.text;
    });
    titleController.addListener(_checkFields);
    descriptionController.addListener(_checkFields);
    allowMultipleSwitchController.value = allowMultiple.value;
    allowMultipleSwitchController.addListener(() {
      allowMultiple.value = allowMultipleSwitchController.value;
    });
    ever(allowMultiple, (val) {
      if (allowMultipleSwitchController.value != val) {
        allowMultipleSwitchController.value = val;
      }
    });
    pollTitleController.addListener(validateCreatePoll);
    ever(pollFields, (_) => validateCreatePoll());
    loadThreads();
  }

  // ------------------------------------------------------------- Discussions -----------------------------------------------------------------

  void _checkFields() {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    isButtonEnabled.value = title.isNotEmpty && desc.isNotEmpty;
  }

  void resetCommentInput() {
  commentController.clear();
  hasInsertedMention.value = false;
  isReplying.value = false;
}


  void _syncThreadIntoList(ForumData updatedThread) {
  final index = threadsList.indexWhere((t) => t.id == updatedThread.id);
  if (index != -1) {
    threadsList[index] = updatedThread;
    threadsList.refresh();
  }

  final originalIndex = originalThreadsList.indexWhere((t) => t.id == updatedThread.id);
  if (originalIndex != -1) {
    originalThreadsList[originalIndex] = updatedThread;
  }
}


  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  Future<void> handleSubmit() async {
    if (!isButtonEnabled.value || isSubmitting.value) return;

    isSubmitting.value = true;

    titleController.text = _capitalizeFirst(titleController.text.trim());
    descriptionController.text = _capitalizeFirst(
      descriptionController.text.trim(),
    );

    await createDiscussion();

    isSubmitting.value = false;
  }

  Future<void> loadThreads() async {
  try {
    final fetchedThreads = await _forumApiService.fetchThreads();

    // Check if data changed compared to current threadsList
    bool dataChanged = _hasThreadsDataChanged(fetchedThreads);

    if (dataChanged) {
      isLoading.value = true;

      // Optional delay for shimmer visibility
      await Future.delayed(const Duration(milliseconds: 300));

      originalThreadsList.assignAll(fetchedThreads);
      threadsList.assignAll(fetchedThreads);

      isLoading.value = false;
    }
    // else data same, no shimmer or UI update needed
  } catch (e) {
    print('Error loading threads: $e');
    isLoading.value = false;
  }
}

bool _hasThreadsDataChanged(List<ForumData> newData) {
  if (threadsList.length != newData.length) return true;

  for (int i = 0; i < newData.length; i++) {
    if (jsonEncode(threadsList[i].toJson()) != jsonEncode(newData[i].toJson())) {
      return true;
    }
  }

  return false;
}



  void resetFields() {
    searchController.clear();
    setSearchQuery('');
  }

  Future<ForumData> loadSingleThread(String id, {bool forceRefresh = false}) async {
  if (!forceRefresh) {
    final cached = originalThreadsList.firstWhereOrNull(
      (t) => t.id == id && t.content != null,
    );

    if (cached != null) {
      singleThread.value = cached;
      comments.value = cached.comments ?? [];
      selectedThreadId.value = id;
      isLiked.value = cached.isLiked ?? false;
      likeCount.value = cached.likeCount?.toString() ?? '0';
      commentCount.value = cached.commentCount?.toString() ?? '0';
      return cached;
    }
  }

  isThreadLoading.value = true;

  try {
    final thread = await _forumApiService.fetchSingleThread(id);

    selectedThreadId.value = id;
    singleThread.value = thread;
    comments.value = thread.comments ?? [];
    isLiked.value = thread.isLiked ?? false;
    likeCount.value = thread.likeCount?.toString() ?? '0';
    commentCount.value = thread.commentCount?.toString() ?? '0';

    final index = originalThreadsList.indexWhere((t) => t.id == id);
    if (index != -1) {
      originalThreadsList[index] = thread;
    } else {
      originalThreadsList.add(thread);
    }

    return thread;
  } catch (e) {
    print('Error loading thread: $e');
    rethrow;
  } finally {
    isThreadLoading.value = false;
  }
  }

  void addImage(XFile image) {
    selectedImages.add(image);
  }

  // Helper to remove images by index
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  void startReply({required String id, required String name}) {
  replyingToId.value = id;
  replyingToName.value = name;
  isReplying.value = true;
  commentController.text = '@$name ';
  commentController.selection = TextSelection.fromPosition(
    TextPosition(offset: commentController.text.length),
  );
  hasInsertedMention.value = true;
  commentFocusNode.requestFocus();
}

  void cancelReply() {
    isReplying.value = false;
    replyingToId.value = '';
    replyingToName.value = '';
    commentController.clear();
    hasInsertedMention.value = false;
  }

  Future<void> postCommentOrReply() async {
  String text = commentController.text.trim();
  if (text.isEmpty) return;

  // Decide whom to mention: thread author or reply target
  final mentionName = isReplying.value && replyingToName.value.isNotEmpty
      ? replyingToName.value.trim()
      : '${singleThread.value?.firstName ?? ''} ${singleThread.value?.lastName ?? ''}'.trim();

  final mention = '@$mentionName';

  // Add caret if the text starts with mention but doesn't have caret
  if (text.startsWith(mention) && !text.startsWith('$mention^')) {
    final rest = text.substring(mention.length).trimLeft();
    text = '$mention^ $rest';
  }

  if (isReplying.value && replyingToId.isNotEmpty) {
    await replyToComment(replyingToId.value, text);
  } else {
    await postComment(text);
  }
  cancelReply();
}

  Future<void> postComment(String text) async {
    try {
      await ForumApiService.postComment(
        threadId: selectedThreadId.value,
        comment: text,
      );
      await loadSingleThread(selectedThreadId.value, forceRefresh: true);
      _syncThreadIntoList(singleThread.value!);
    } catch (e) {
      String message = _getFriendlyErrorMessage(e);
      CustomSnackbars.failure(message, "Failed to post Comment");
    }
  }

  void applyFilters() {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      threadsList.assignAll(originalThreadsList);
      return;
    }

    final filtered =
        originalThreadsList.where((thread) {
          final title = thread.title?.toLowerCase() ?? '';
          return title.contains(query);
        }).toList();

    threadsList.assignAll(filtered);
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  Future<void> likeComment(String commentId) async {
    final index = comments.indexWhere((c) => c.id == commentId);
    if (index == -1) return;

    final oldComment = comments[index];
    final liked = !(oldComment.isLiked ?? false);
    final currentCount = int.tryParse(oldComment.likeCount ?? '0') ?? 0;

    // Optimistic UI update
    final updatedComment = oldComment.copyWith(
      isLiked: liked,
      likeCount: (liked ? currentCount + 1 : currentCount - 1).toString(),
    );
    comments[index] = updatedComment;
    comments.refresh();

    try {
      await _forumApiService.likeComment(commentId);
    } catch (e) {
      // Revert on failure
      comments[index] = oldComment;
      comments.refresh();
      String message = _getFriendlyErrorMessage(e);
      CustomSnackbars.failure(message, "Failed to like Comment");
    }
  }

  Future<void> likeReply(String replyId) async {
    for (int i = 0; i < comments.length; i++) {
      final replies = comments[i].replies;
      if (replies == null) continue;

      final replyIndex = replies.indexWhere((r) => r.id == replyId);
      if (replyIndex != -1) {
        final oldReply = replies[replyIndex];
        final liked = !(oldReply.isLiked ?? false);
        final currentCount = int.tryParse(oldReply.likeCount ?? '0') ?? 0;

        final updatedReply = oldReply.copyWith(
          isLiked: liked,
          likeCount: (liked ? currentCount + 1 : currentCount - 1).toString(),
        );
        replies[replyIndex] = updatedReply;

        // Re-assign to trigger reactive update
        comments[i] = comments[i].copyWith(
          replies: List<Replies>.from(replies),
        );
        comments.refresh();

        try {
          await _forumApiService.likeReply(replyId);
        } catch (e) {
          // Revert on failure
          replies[replyIndex] = oldReply;
          comments[i] = comments[i].copyWith(
            replies: List<Replies>.from(replies),
          );
          comments.refresh();
          String message = _getFriendlyErrorMessage(e);
          CustomSnackbars.failure(message, "Failed to like Reply");
        }
        break;
      }
    }
  }

  Future<void> likeThread([String? threadId]) async {
    final id = threadId ?? selectedThreadId.value;

    // Find index in the list
    final index = threadsList.indexWhere((thread) => thread.id == id);
    if (index == -1) return;

    final thread = threadsList[index];
    final currentStatus = thread.isLiked ?? false;
    final updatedLikeCount = (thread.likeCount ?? 0) + (currentStatus ? -1 : 1);

    // Optimistically update list
    threadsList[index] = thread.copyWith(
      isLiked: !currentStatus,
      likeCount: updatedLikeCount,
    );

    // ✅ If the liked thread is also the one shown in detail, update its state
    if (selectedThreadId.value == id) {
      isLiked.value = !currentStatus;
      likeCount.value = updatedLikeCount.toString();
    }

    try {
      await ForumApiService.likeThread(id);

      // Optional: reload the updated thread from server
      final updatedThread = await loadSingleThread(id, forceRefresh: true);
      _syncThreadIntoList(singleThread.value!);

      threadsList[index] = updatedThread;

      if (selectedThreadId.value == id) {
        singleThread.value = updatedThread;
        isLiked.value = updatedThread.isLiked ?? false;
        likeCount.value = updatedThread.likeCount?.toString() ?? '0';
        commentCount.value = updatedThread.commentCount?.toString() ?? '0';
      }
    } catch (e) {
      // Revert change if API call fails
      threadsList[index] = thread;

      if (selectedThreadId.value == id) {
        isLiked.value = currentStatus;
        likeCount.value = (thread.likeCount ?? 0).toString();
      }

      String message = _getFriendlyErrorMessage(e);
      CustomSnackbars.failure(message, "Failed to Update Like");
    }
  }

  Future<void> replyToComment(String commentId, String content) async {
    try {
      await ForumApiService.postReply(
        threadId: selectedThreadId.value,
        commentId: commentId,
        reply: content,
      );
      await loadSingleThread(selectedThreadId.value, forceRefresh: true);
      _syncThreadIntoList(singleThread.value!);
    } catch (e) {
      String message = _getFriendlyErrorMessage(e);
      CustomSnackbars.failure(message, "Failed to Reply");
    }
  }

  Future<void> createDiscussion() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      CustomSnackbars.failure("Error", "Title and description cannot be empty");
      return;
    }
    try {
      isLoading.value = true;
      await ForumApiService.postDiscussion(
        title: title,
        description: description,
        images: selectedImages,
      );
      await loadThreads();
      titleController.clear();
      descriptionController.clear();
      selectedImages.clear();
      Get.back();
    } catch (e) {
      String message = _getFriendlyErrorMessage(e);
      CustomSnackbars.failure(message, "Failed to Create Discussion");
    } finally {
      isLoading.value = false;
    }
  }

  //------------------------------------------------------------- Polls ------------------------------------------------------------------------

  Future<void> loadPolls() async {
    try {
      final fetchedPolls = await _pollApiService.fetchAllPoll();

      // Check if data changed compared to current pollsList
      bool dataChanged = _hasPollsDataChanged(fetchedPolls);

      if (dataChanged) {
        isLoading.value = true;

        // Optional delay for shimmer visibility
        await Future.delayed(const Duration(milliseconds: 300));

        pollsList.assignAll(fetchedPolls);
        filteredPolls.assignAll(pollsList);
        selectedPollAnswers.clear();

        for (final poll in pollsList) {
          initializeSelectedOptions(poll);
        }

        isLoading.value = false;
      }
      // else data same, no shimmer or UI update needed
    } catch (e) {
      print('Error loading polls: $e');
      isLoading.value = false;
    }
  }

  /// Helper method to compare current pollsList with new fetched polls
  bool _hasPollsDataChanged(List<PollData> newPolls) {
    if (pollsList.length != newPolls.length) return true;

    for (int i = 0; i < newPolls.length; i++) {
      final oldJson = jsonEncode(pollsList[i].toJson());
      final newJson = jsonEncode(newPolls[i].toJson());
      if (oldJson != newJson) return true;
    }
    return false;
  }

  void setPollSearchQuery(String query) {
    pollSearchQuery.value = query;
    filterPolls();
  }

  void filterPolls() {
    final query = pollSearchQuery.value.toLowerCase();
    if (query.isEmpty) {
      filteredPolls.assignAll(pollsList);
    } else {
      filteredPolls.assignAll(
        pollsList.where(
          (poll) => poll.title?.toLowerCase().contains(query) == true,
        ),
      );
    }
  }

  Future<void> loadPollReactions(String id) async {
  try {
    isPollReactionsLoading.value = true;

    final pollReactionModel = await _pollApiService.fetchPollReactions(id);

    if (pollReactionModel.data != null) {
      pollReactionList.assignAll(pollReactionModel.data!);
    } else {
      pollReactionList.clear();
    }

    totalVotes.value = pollReactionModel.totalVotes ?? 0;
  } catch (e) {
    print('Error loading poll reactions: $e');
  } finally {
    isPollReactionsLoading.value = false;
  }
}


  Future<void> submitPoll() async {
    if (pollTitleController.text.trim().isEmpty || pollFields.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    try {
      isLoading.value = true;

      await PollApiService.createPoll(
        title: pollTitleController.text.trim(),
        description: pollDescriptionController.text.trim(),
        pollFields: pollFields,
        expiryDate: pollExpiryDate.value.toString(),
        allowMultiple: allowMultiple.value,
      );

      Get.snackbar('Success', 'Poll created successfully');
      // Optionally clear the form after success
      pollTitleController.clear();
      pollDescriptionController.clear();
      pollExpiryDate.value = null;
      pollFields.clear();
      allowMultiple.value = false;
    } catch (e) {
      CustomSnackbars.oops("Poll creation failed", "Oops");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePoll(String pollId) async {
    try {
      isLoading.value = true;

      await PollApiService.editPoll(
        pollId: pollId,
        title: pollTitleController.text.trim(),
        description: pollDescriptionController.text.trim(),
        pollFields: pollFields,
        expiryDate: pollExpiryDate.value.toString(),
        allowMultiple: allowMultiple.value,
      );

      CustomSnackbars.success('Poll updated successfully','Success');
      // Optionally clear the form after success
      pollTitleController.clear();
      pollDescriptionController.clear();
      pollExpiryDate.value = null;
      pollFields.clear();
      allowMultiple.value = false;
    } catch (e) {
      CustomSnackbars.oops("Poll creation failed", "Oops");
    } finally {
      isLoading.value = false;
    }
  }

  void validateCreatePoll() {
    final hasQuestion = pollTitleController.text.trim().isNotEmpty;
    final hasEnoughOptions = pollFields.length >= 2;
    final hasExpiryDate = pollExpiryDate.value != null;

    isCreatePollEnabled.value =
        hasQuestion && hasEnoughOptions && hasExpiryDate;
  }

  void initializeSelectedOptions(PollData poll) {
    final selected = <int>{};
    final options = _parseOptions(poll.pollFeild ?? '');

    if (poll.userVote != null) {
      try {
        final decoded = jsonDecode(poll.userVote!);

        if (decoded is List) {
          for (var vote in decoded) {
            final idx = options.indexOf(vote.toString());
            if (idx != -1) selected.add(idx);
          }
        } else if (decoded is String) {
          final idx = options.indexOf(decoded);
          if (idx != -1) selected.add(idx);
        }
      } catch (e) {
        final idx = options.indexOf(poll.userVote!);
        if (idx != -1) selected.add(idx);
      }
    }

    selectedPollAnswers[poll.id!] = selected; // use poll.id
  }

  // In ForumController.dart
  void togglePollOption(String pollId, int optionIndex, bool isMultiple) {
    final pollIndex = pollsList.indexWhere((p) => p.id == pollId);
    if (pollIndex == -1) return;

    final selected = selectedPollAnswers[pollId] ?? <int>{};
    final pollData = pollsList[pollIndex];
    final options = _parseOptions(pollData.pollFeild ?? '');
    final updatedCounts = Map<String, num>.from(pollData.reactionCounts);
    final tappedOptionName = options[optionIndex];

    // Update logic same as before
    if (isMultiple) {
      if (selected.contains(optionIndex)) {
        selected.remove(optionIndex);
        updatedCounts[tappedOptionName] =
            (updatedCounts[tappedOptionName] ?? 1) - 1;
      } else {
        selected.add(optionIndex);
        updatedCounts[tappedOptionName] =
            (updatedCounts[tappedOptionName] ?? 0) + 1;
      }
    } else {
      if (selected.contains(optionIndex)) {
        selected.clear();
        updatedCounts[tappedOptionName] =
            (updatedCounts[tappedOptionName] ?? 1) - 1;
      } else {
        if (selected.isNotEmpty) {
          final prevOptionName = options[selected.first];
          updatedCounts[prevOptionName] =
              (updatedCounts[prevOptionName] ?? 1) - 1;
        }
        selected
          ..clear()
          ..add(optionIndex);
        updatedCounts[tappedOptionName] =
            (updatedCounts[tappedOptionName] ?? 0) + 1;
      }
    }

    selectedPollAnswers[pollId] = selected;

    // ✅ Update both lists
    final updatedPoll = pollData.copyWith(reactionCounts: updatedCounts);
    pollsList[pollIndex] = updatedPoll;

    final filteredIndex = filteredPolls.indexWhere((p) => p.id == pollId);
    if (filteredIndex != -1) {
      filteredPolls[filteredIndex] = updatedPoll;
    }

    // Send single tapped item to backend
    _submitPollVote(pollId, tappedOptionName);
  }

  /// Final method now only needs pollId and selected reaction
  Future<void> _submitPollVote(String pollId, String reaction) async {
    try {
      await PollApiService.submitPollReaction(
        pollId: pollId,
        reaction: reaction,
      );
    } catch (e) {
      debugPrint('Error submitting poll vote: $e');
    }
  }

  String _getFriendlyErrorMessage(dynamic e) {
    if (e is DioError) {
      if (e.response != null && e.response?.data != null) {
        // Handle backend error message if available
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          return e.response?.data['message'];
        }
      }
      return "Network error: ${e.message}";
    } else if (e is SocketException) {
      return "No internet connection. Please check your network.";
    } else if (e is TimeoutException) {
      return "Request timed out. Please try again.";
    } else {
      return "Something went wrong. Please try again.";
    }
  }

  /// Extract options from JSON or comma separated text
  List<String> _parseOptions(String pollFeild) {
    try {
      final decoded = jsonDecode(pollFeild);
      if (decoded is List) {
        return decoded.map((e) => e.toString().trim()).toList();
      }
    } catch (e) {
      print(e);
    }
    return pollFeild.split(',').map((e) => e.trim()).toList();
  }

  //report & block
   String selectedReason = '';
  bool isReportSubmitting = false;
  final TextEditingController detailsController = TextEditingController();

  final List<ReportReason> reasons = [
    ReportReason(
      title: "Spam or Scam",
      subtitle: "Unwanted commercial content or fraudulent activity",
      icon: Icons.local_offer_outlined,
    ),
    ReportReason(
      title: "Harassment or Bullying",
      subtitle: "Abusive behavior or targeted harassment",
      icon: Icons.sentiment_very_dissatisfied_outlined,
    ),
    ReportReason(
      title: "Inappropriate Content",
      subtitle: "Offensive or inappropriate material",
      icon: Icons.warning_amber_outlined,
    ),
    ReportReason(
      title: "Fake Profile",
      subtitle: "Impersonation or misleading identity",
      icon: Icons.person_off_outlined,
    ),
    ReportReason(
      title: "Other",
      subtitle: "Something else that violates our guidelines",
      icon: Icons.more_horiz,
    ),
  ];

  void selectReason(String reason) {
    selectedReason = reason;
    update();
  }

  Future<void> blockUser({
    required String userId,
    required String userType,
    required String blockedUserId,
    required String blockedUserType,
  }) async {
    try {
      await _reportApiServices.blockUser(
        userId: userId, 
        userType: userType,
        blockedUserId: blockedUserId,
        blockedUserType: blockedUserType,
      );
    } catch (e) {
      CustomSnackbars.failure("Error", "Failed to block user: $e");
    }
  }

  Future<void> flagUser({
    required String blockedUserId,
    required String blockedUsertype,
    required String userId,
    required String userType,
    String pollId = '',
    String threadId = '',
    String commentId = '',
    String replyId = '',
    required String reason,
    String additionalDetails = '',
  }) async {
    isReportSubmitting = true;
    update();
    try {
      await _reportApiServices.flagUser(
        blockedUserId: blockedUserId,
        blockedUsertype: blockedUsertype,
        userId: userId,
        pollId: pollId,
        userType: userType,
        threadId: threadId,
        commentId: commentId,
        replyId: replyId,
        reason: reason,
        additionalDetails: additionalDetails,
      );
    } catch (e) {
      CustomSnackbars.failure( "Failed to flag user: $e","Error",);
    } finally {
      isReportSubmitting = false;
      update();
    }
  }

  @override
  void onClose() {
    detailsController.dispose();
    super.onClose();
  }
}

class ReportReason {
  final String title;
  final String subtitle;
  final IconData icon;

  ReportReason({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}