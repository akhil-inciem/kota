import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/apiServices/news_api_service.dart';
import 'package:kota/model/news_model.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  var selectedTabIndex = 0.obs;
  final isLoading = false.obs;
  final newsItems = <NewsDatum>[].obs;
  final RxList<NewsDatum> filteredNewsItems = <NewsDatum>[].obs;
  final Rxn<NewsDatum> selectedNewsItem = Rxn<NewsDatum>();
  final favoriteItemList = <NewsDatum>[].obs;
  var bookmarkedStatus = <String, bool>{}.obs;
  final _favApiService = FavoritesApiService();
  final NewsApiService _newsApiService = NewsApiService();
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  void toggleBookmark(String id) async {
  final currentStatus = bookmarkedStatus[id] ?? false;
  final newStatus = !currentStatus;
  bookmarkedStatus[id] = newStatus;
  try {
    await _favApiService.sendNewsBookmarkStatusToApi(id, newStatus);
  } catch (e) {
    print("Failed to update bookmark status: $e");
    bookmarkedStatus[id] = currentStatus;
  }
}

  Future<void> fetchSingleNewsItem(String newsId) async {
  isLoading.value = true;
  selectedNewsItem.value = null;

  try {
    final newsItem = await _newsApiService.fetchNewsById(
      newsId: newsId,
    );

    if (newsItem != null) {
      selectedNewsItem.value = newsItem;
      final index = newsItems.indexWhere((item) => item.newsId == newsId);
      if (index != -1) {
        newsItems[index] = newsItem;
        filteredNewsItems[index] = newsItem;
      } else {
        newsItems.add(newsItem);
        filteredNewsItems.add(newsItem);
      }
      if (newsItem.newsId != null) {
        bookmarkedStatus[newsItem.newsId!] = newsItem.favorites == 1;
      }
    }
  } catch (e) {
    print("Error fetching single news item: $e");
  } finally {
    isLoading.value = false;
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

void clearSelectedNews() {
  selectedNewsItem.value = null;
  bookmarkedStatus.clear();
}

}