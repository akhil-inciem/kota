import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/apiServices/news_api_service.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/news_model.dart';
import 'package:kota/model/user_model.dart';
import '../constants/app_constants.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  final isLoading = true.obs;
  final newsItems = <Datum>[].obs;
  final favoriteItemList = <Datum>[].obs;
  var bookmarkedStatus = <String, bool>{}.obs;
  final _favApiService = FavoritesApiService();

  @override
  void onInit() {
    super.onInit();
    fetchNewsItems();
  }

  void toggleBookmark(String id) async {
  final currentStatus = bookmarkedStatus[id] ?? false;
  final newStatus = !currentStatus;

  // Update local state immediately for UI feedback
  bookmarkedStatus[id] = newStatus;

  // Now send it to the API
  try {
    await _favApiService.sendBookmarkStatusToApi(id, newStatus);
  } catch (e) {
    print("Failed to update bookmark status: $e");

    // Optionally revert if API fails
    bookmarkedStatus[id] = currentStatus;
  }
}


  Future<void> fetchNewsItems() async {
  isLoading.value = true;

  try {
    NewsModel news = NewsModel.fromJson(DummyData.news);
    newsItems.assignAll(news.data);
  } catch (e) {
    print("Error fetching news: $e");
  } finally {
    isLoading.value = false;
  }
}

}
