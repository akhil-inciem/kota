import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/apiServices/news_api_service.dart';
import 'package:kota/model/news_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';

import '../model/advertisement_model.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  var selectedTabIndex = 0.obs;
  RxInt currentAdIndex = 0.obs;

  final isLoading = true.obs;
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

  /// Compares current news list with new fetched data to detect changes
  bool _hasDataChanged(List<NewsDatum> newData) {
    if (masterNewsItems.length != newData.length) return true;

    for (int i = 0; i < newData.length; i++) {
      final oldJson = jsonEncode(masterNewsItems[i].toJson());
      final newJson = jsonEncode(newData[i].toJson());
      if (oldJson != newJson) return true;
    }
    return false;
  }

  Future<void> fetchNewsItems() async {
    try {
      final List<NewsDatum> fetchedNews = await _newsApiService.fetchNews();
      final List<NewsDatum> reversedNews = fetchedNews.reversed.toList();

      final changed = _hasDataChanged(reversedNews);

      if (changed) {
        isLoading.value = true;

        // Optional delay to allow shimmer visibility
        await Future.delayed(const Duration(milliseconds: 300));

        masterNewsItems.assignAll(reversedNews);
        filteredNewsItems.assignAll(reversedNews);

        isLoading.value = false;
        _hasFetchedNews = true;
      }
      // else: data same, do nothing, no shimmer
    } catch (e) {
      print("Error fetching news: $e");
      isLoading.value = false;
    }
  }

void toggleBookmark(String id) async {
  final currentStatus = bookmarkedStatus[id] ?? false;
  final newStatus = !currentStatus;

  // Update observable map
  bookmarkedStatus[id] = newStatus;
  bookmarkedStatus.refresh();

  // ✅ Update in masterNewsItems
  final index = masterNewsItems.indexWhere((item) => item.newsId == id);
  if (index != -1) {
    masterNewsItems[index] = masterNewsItems[index].copyWith(
      favorites: newStatus ? 1 : 0,
    );
  }

  // ✅ Update in selectedNewsItem if currently open
  final selected = selectedNewsItem.value;
  if (selected != null && selected.newsId == id) {
    selectedNewsItem.value = selected.copyWith(
      favorites: newStatus ? 1 : 0,
    );
  }

  try {
    await _favApiService.sendNewsBookmarkStatusToApi(id, newStatus);
  } catch (e) {
    print("Failed to update bookmark status: $e");

    // Rollback observable
    bookmarkedStatus[id] = currentStatus;
    bookmarkedStatus.refresh();

    // Rollback model changes
    if (index != -1) {
      masterNewsItems[index] = masterNewsItems[index].copyWith(
        favorites: currentStatus ? 1 : 0,
      );
    }

    if (selected != null && selected.newsId == id) {
      selectedNewsItem.value = selected.copyWith(
        favorites: currentStatus ? 1 : 0,
      );
    }
  }
}

  Future<void> fetchSingleNewsItem(String newsId) async {
  final existingItem = masterNewsItems.cast<NewsDatum?>().firstWhere(
  (item) => item?.newsId == newsId && item?.favorites != null,
  orElse: () => null,
);

if (existingItem != null) {
  selectedNewsItem.value = existingItem;
  isLoadingNewsItem.value = false;

  bookmarkedStatus[existingItem.newsId!] = existingItem.favorites == 1;
  bookmarkedStatus.refresh();
  return;
}

  // ❗ API call fallback
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
        bookmarkedStatus.refresh(); // ✅ Important
      }
    }

    isLoadingNewsItem.value = false;
  } catch (e) {
    print("Error fetching single news item: $e");
  } finally {
    isLoading.value = false;
  }
}


  Future<void> loadAdvertisements() async {
  final adModel = await _newsApiService.fetchAdvertisement();
  if (adModel != null && adModel.data?.advertisements != null) {
    advertisements.assignAll(adModel.data!.advertisements!);
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
