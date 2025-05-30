
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/forum_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/forum_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';

class ForumController extends GetxController {
  final isLoading = true.obs;
  final selectedImages = <XFile>[].obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RxString selectedThreadId = ''.obs;
  final forumModel = Rxn<ForumModel>();
  final threadsList = <ForumData>[].obs;
  final originalThreadsList = <ForumData>[]; 
  final RxBool isButtonEnabled = false.obs;
  final RxBool isSubmitting = false.obs;
  var comments = <Comments>[].obs;
  final Rx<ForumData> singleThread = ForumData().obs;
  final ForumApiService _forumApiService = ForumApiService();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final isReplying = false.obs;
  final replyingToId = ''.obs;
  final searchQuery = ''.obs;
  var isLiked = false.obs;
  var likeCount = '0'.obs;
  var commentCount = '0'.obs;

  final FocusNode commentFocusNode = FocusNode();

  RxString replyingToName = ''.obs; // Optional: To show UI hint

  @override
  void onInit() {
    super.onInit();
    titleController.addListener(_checkFields);
    descriptionController.addListener(_checkFields);
    loadThreads();
  }

  void _checkFields() {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    isButtonEnabled.value = title.isNotEmpty && desc.isNotEmpty;
  }

  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  Future<void> handleSubmit() async {
    if (!isButtonEnabled.value || isSubmitting.value) return;

    isSubmitting.value = true;

    titleController.text = _capitalizeFirst(titleController.text.trim());
    descriptionController.text = _capitalizeFirst(descriptionController.text.trim());

    await createDiscussion();

    isSubmitting.value = false;
  }

  Future<void> loadThreads() async {
    try {
      isLoading.value = true;
      final fetchedThreads = await _forumApiService.fetchThreads();
      originalThreadsList.assignAll(fetchedThreads);
      threadsList.assignAll(fetchedThreads);
    } catch (e) {
      print('Error loading threads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields(){
    searchController.clear();
    setSearchQuery('');
  }

  Future<ForumData> loadSingleThread(String id) async {
    try {
      final thread = await _forumApiService.fetchSingleThread(id);
      singleThread.value = thread;
      comments.value = thread.comments ?? [];
      isLiked.value = thread.isLiked ?? false;
      likeCount.value = thread.likeCount?.toString() ?? '0';
      commentCount.value = thread.commentCount?.toString() ?? '0';
      return thread;
    } catch (e) {
      print('Error loading threads: $e');
      rethrow;
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
  void startReply({required String id}) {
    replyingToId.value = id;
    isReplying.value = true;
    commentFocusNode.requestFocus();
  }

  void cancelReply() {
    isReplying.value = false;
    replyingToId.value = '';
    commentController.clear();
  }

  Future<void> postCommentOrReply() async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    if (isReplying.value && replyingToId.isNotEmpty) {
      await replyToComment(replyingToId.value, text);
    } else {
      // Call comment API
      await postComment();
    }
    cancelReply();
    loadSingleThread(selectedThreadId.value); // Reload thread
  }

  Future<void> postComment() async {
    try {
      await ForumApiService.postComment(
        threadId: selectedThreadId.value,
        comment: commentController.text,
      );
      await loadSingleThread(selectedThreadId.value);
    } catch (e) {
      String message = _getFriendlyErrorMessage(e);
    CustomSnackbars.failure( message,"Failed to post Comment");
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
          final description = thread.content?.toLowerCase() ?? '';
          return title.contains(query) || description.contains(query);
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
    CustomSnackbars.failure( message,"Failed to like Comment");
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
      comments[i] = comments[i].copyWith(replies: List<Replies>.from(replies));
      comments.refresh();

      try {
        await _forumApiService.likeReply(replyId);
      } catch (e) {
        // Revert on failure
        replies[replyIndex] = oldReply;
        comments[i] = comments[i].copyWith(replies: List<Replies>.from(replies));
        comments.refresh();
        String message = _getFriendlyErrorMessage(e);
    CustomSnackbars.failure( message,"Failed to like Reply");
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
      final updatedThread = await loadSingleThread(id);

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
    CustomSnackbars.failure( message,"Failed to Update Like");
    }
  }

  

  Future<void> replyToComment(String commentId, String content) async {
    try {
      await ForumApiService.postReply(
        threadId: selectedThreadId.value,
        commentId: commentId,
        reply: content,
      );
      await loadSingleThread(selectedThreadId.value);
    } catch (e) {
      String message = _getFriendlyErrorMessage(e);
    CustomSnackbars.failure( message,"Failed to Reply");
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
    CustomSnackbars.failure( message,"Failed to Create Discussion");
    }finally{
      isLoading.value = false;
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


  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
