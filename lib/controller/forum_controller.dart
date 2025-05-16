import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/forum_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/forum_model.dart';
import 'package:share_plus/share_plus.dart';

class ForumController extends GetxController {
  final isLoading = true.obs;
  final selectedImages = <XFile>[].obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  RxString selectedThreadId = ''.obs;
  final forumModel = Rxn<ForumModel>();
  final threadsList = <ForumData>[].obs;
  final Rx<ForumData> singleThread = ForumData().obs;
  final ForumApiService _forumApiService = ForumApiService();
  final TextEditingController commentController = TextEditingController();

  final isReplying = false.obs;
  final replyingToId = ''.obs;
  // Focus node for controlling keyboard focus
  final FocusNode commentFocusNode = FocusNode();

  RxString replyingToName = ''.obs; // Optional: To show UI hint

  @override
  void onInit() {
    super.onInit();
    loadThreads();
  }

  Future<void> loadThreads() async {
    try {
      isLoading.value = true;
      threadsList.value = await _forumApiService.fetchThreads();
    } catch (e) {
      print('Error loading threads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSingleThread(String id) async {
    try {
      final data = await _forumApiService.fetchSingleThread(id);
      singleThread.value = data;
    } catch (e) {
      print('Error loading threads: $e');
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

  // Convert to paths for API
  List<String> getImagePaths() {
    return selectedImages.map((img) => img.path).toList();
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
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> likeComment(String commentID) async {
    try {
      await ForumApiService.likeComment(commentID);
      await loadSingleThread(selectedThreadId.value);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> likeThread([String? threadId]) async {
  final id = threadId ?? selectedThreadId.value;
  try {
    await ForumApiService.likeThread(id);
    await loadSingleThread(id);
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}


  Future<void> likeReply(String replyId) async {
    try {
      await ForumApiService.likeReply(replyId);
      await loadSingleThread(selectedThreadId.value);
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> createDiscussion() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      Get.snackbar("Error", "Title and description cannot be empty");
      return;
    }
    try {
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
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
