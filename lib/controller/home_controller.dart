import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/apiServices/news_api_service.dart';
import 'package:kota/model/news_model.dart';

import '../model/advertisement_model.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  var selectedTabIndex = 0.obs;

  final isLoading = false.obs;
  bool _hasFetchedNews = false;


  final RxList<NewsDatum> masterNewsItems = <NewsDatum>[].obs;
  final RxList<NewsDatum> filteredNewsItems = <NewsDatum>[].obs;

  final Rxn<NewsDatum> selectedNewsItem = Rxn<NewsDatum>();
  final favoriteItemList = <NewsDatum>[].obs;
  final bookmarkedStatus = <String, bool>{}.obs;

  final _favApiService = FavoritesApiService();
  final _newsApiService = NewsApiService();
  final RxBool isLoadingNewsItem = true.obs;

  final TextEditingController searchController = TextEditingController();
  RxList<Advertisements> advertisements = <Advertisements>[].obs;

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

  Future<void> loadAdvertisements() async {
  final adModel = await _newsApiService.fetchAdvertisement();
  if (adModel != null && adModel.data?.advertisements != null) {
    advertisements.assignAll(adModel.data!.advertisements!);
  }
}

  Future<void> fetchSingleNewsItem(String newsId) async {
    isLoading.value = true;
    selectedNewsItem.value = null;
    try {
      final newsItem = await _newsApiService.fetchNewsById(newsId: newsId);

      if (newsItem != null) {
        selectedNewsItem.value = newsItem;

        final index = masterNewsItems.indexWhere((item) => item.newsId == newsId);
        if (index != -1) {
          masterNewsItems[index] = newsItem;
          final filteredIndex = filteredNewsItems.indexWhere((item) => item.newsId == newsId);
          if (filteredIndex != -1) {
            filteredNewsItems[filteredIndex] = newsItem;
          }
        } else {
          masterNewsItems.add(newsItem);
          filteredNewsItems.add(newsItem);
        }

        if (newsItem.newsId != null) {
          bookmarkedStatus[newsItem.newsId!] = newsItem.favorites == 1;
        }
      }
      isLoadingNewsItem.value = false;
    } catch (e) {
      print("Error fetching single news item: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNewsItems() async {
  if (_hasFetchedNews) return; // prevent refetching

  isLoading.value = true;

  try {
    final List<NewsDatum> fetchedNews = await _newsApiService.fetchNews();
    masterNewsItems.assignAll(fetchedNews);
    filteredNewsItems.assignAll(fetchedNews);
    _hasFetchedNews = true;
  } catch (e) {
    print("Error fetching news: $e");
  } finally {
    isLoading.value = false;
  }
}

  void filterNews(String query) {
    if (query.isEmpty) {
      filteredNewsItems.assignAll(masterNewsItems);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredNewsItems.assignAll(
        masterNewsItems.where(
          (item) =>
              item.newsTitle?.toLowerCase().contains(lowerQuery) == true ||
              item.newsDescription?.toLowerCase().contains(lowerQuery) == true,
        ),
      );
    }
  }

}
