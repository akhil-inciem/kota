import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/model/favorite_model.dart';

class FavouriteController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<String?> selectedCategory = Rx<String?>(null);
  final isLoading = true.obs;
  final searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final allItems = <Map<String, dynamic>>[].obs; // Stores all news + events
  final filteredList = <Map<String, dynamic>>[].obs;

  final FavoritesApiService _favoritesApiService = FavoritesApiService();
  
  bool _hasFetchedFavorites = false; // <-- NEW FLAG

  @override
  void onInit() {
    super.onInit();
    fetchFilteredItems();
  }

  Future<void> fetchFilteredItems() async {
    if (_hasFetchedFavorites) return; // <-- Prevent re-fetching

    try {
      isLoading.value = true;

      FavoritesModel favoritesModel = await _favoritesApiService.fetchFavorites();

      final List<Map<String, dynamic>> combinedList = [];

      // Combine news
      if (favoritesModel.data?.favoriteNews != null) {
        for (var news in favoritesModel.data!.favoriteNews!) {
          combinedList.add({
            'type': 'news',
            'title': news.newsTitle ?? '',
            'description': news.newsDescription ?? '',
            'date': DateTime.tryParse(news.newsDate.toString()) ?? DateTime.now(),
            'badge': news.badges ?? '',
            'image': news.newsImage ?? '',
            'data': news,
          });
        }
      }

      // Combine events
      if (favoritesModel.data?.favoriteEvents != null) {
        for (var event in favoritesModel.data!.favoriteEvents!) {
          combinedList.add({
            'type': 'event',
            'title': event.eventName ?? '',
            'description': event.eventDescription ?? '',
            'date': DateTime.tryParse(event.eventstartDateDate?.toString() ?? '') ?? DateTime.now(),
            'badge': event.badges ?? '',
            'image': event.image ?? '',
            'data': event,
          });
        }
      }

      allItems.assignAll(combinedList);
      filteredList.assignAll(combinedList);
      _hasFetchedFavorites = true; // <-- Mark as fetched
    } catch (e) {
      print("Error fetching favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    filteredList.value = allItems.where((item) {
      bool matchesDate = true;
      bool matchesCategory = true;
      bool matchesSearch = true;

      if (selectedDate.value != null) {
        DateTime itemDate = item['date'];
        matchesDate = itemDate.year == selectedDate.value!.year &&
            itemDate.month == selectedDate.value!.month &&
            itemDate.day == selectedDate.value!.day;
      }

      final itemBadge = (item['badge'] ?? '').toString().toLowerCase().trim();
      final selectedBadge = (selectedCategory.value ?? '').toLowerCase().trim();
      if (selectedCategory.value != null && selectedBadge.isNotEmpty && selectedBadge != 'none') {
        matchesCategory = itemBadge == selectedBadge;
      }

      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final title = (item['title'] ?? '').toString().toLowerCase();
        matchesSearch = title.contains(query);
      }

      return matchesDate && matchesCategory && matchesSearch;
    }).toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void resetFilters() {
    selectedDate.value = null;
    selectedCategory.value = null;
    searchQuery.value = '';
    searchController.clear();
    setSearchQuery('');
    filteredList.assignAll(allItems);
  }

  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;
  }

  void setSelectedCategory(String? category) {
    selectedCategory.value = category;
  }
}
