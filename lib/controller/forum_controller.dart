import 'package:get/get.dart';
import 'package:kota/data/dummy.dart';
import 'package:share_plus/share_plus.dart';

class ForumController extends GetxController {
  final isLoading = true.obs;
  final forumItems = <Map<String, dynamic>>[].obs;
  final selectedImages = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecommendedItems();
  }

  Future<void> fetchRecommendedItems() async {
    isLoading.value = true;
    
    await Future.delayed(const Duration(seconds: 1)); 
    forumItems.value = DummyData.forumItems;
    isLoading.value = false;
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

  void toggleLike(String itemId) async {
  final index = forumItems.indexWhere((item) => item['id'] == itemId);
  if (index == -1) return;

  final currentItem = forumItems[index];
  final isLiked = currentItem['isLiked'] ?? false;
  final currentLikes = int.tryParse(currentItem['likes'] ?? '0') ?? 0;

  // Update locally
  forumItems[index] = {
    ...currentItem,
    'isLiked': !isLiked,
    'likes': (!isLiked ? (currentLikes + 1) : (currentLikes - 1)).toString()
  };

  update(); // optional if using GetBuilder

  // Mock API call
  await Future.delayed(Duration(milliseconds: 200));
  print(isLiked ? 'Unliked post $itemId' : 'Liked post $itemId');
}

}