import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/apiServices/news_api_service.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/news_model.dart';
import 'package:kota/model/user_model.dart';
import '../constants/app_constants.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  var selectedTabIndex = 0.obs;
  final isLoading = true.obs;
  final newsItems = <NewsDatum>[].obs;
  final RxList<NewsDatum> filteredNewsItems = <NewsDatum>[].obs;
  final favoriteItemList = <NewsDatum>[].obs;
  var bookmarkedStatus = <String, bool>{}.obs;
  final _favApiService = FavoritesApiService();
  final NewsApiService _newsApiService = NewsApiService();

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
    final List<NewsDatum> fetchedNews = await _newsApiService.fetchNews();
    newsItems.assignAll(fetchedNews);
    filteredNewsItems.assignAll(fetchedNews);
  } catch (e) {
    print("Error fetching news: $e");
  } finally {
    isLoading.value = false;
  }
}

void filterNews(String query) {
  if (query.isEmpty) {
    filteredNewsItems.assignAll(newsItems);
  } else {
    filteredNewsItems.assignAll(
      newsItems.where(
        (item) =>
            item.newsTitle?.toLowerCase().contains(query.toLowerCase()) == true ||
            item.newsDescription?.toLowerCase().contains(query.toLowerCase()) == true,
      ),
    );
  }
}
}