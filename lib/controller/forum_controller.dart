import 'package:get/get.dart';
import 'package:kota/data/dummy.dart';

class ForumController extends GetxController {
  final isLoading = true.obs;
  final forumItems = <Map<String, dynamic>>[].obs;

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
}