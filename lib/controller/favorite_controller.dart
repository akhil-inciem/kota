import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/model/favorite_model.dart';

class FavouriteController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<String?> selectedCategory = Rx<String?>(null);
  final isLoading = false.obs; // Initially false, shimmer shows only on data change
  final searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final allItems = <Map<String, dynamic>>[].obs; // Stores all news + events
  final filteredList = <Map<String, dynamic>>[].obs;

  final FavoritesApiService _favoritesApiService = FavoritesApiService();

  /// Compares current data with new data to detect change
  bool _hasDataChanged(List<Map<String, dynamic>> newData) {
  if (allItems.length != newData.length) return true;

  for (int i = 0; i < newData.length; i++) {
    final oldJson = jsonEncode(normalizeMap(allItems[i]));
    final newJson = jsonEncode(normalizeMap(newData[i]));
    if (oldJson != newJson) return true;
  }
  return false;
}

  Map<String, dynamic> normalizeMap(Map<String, dynamic> input) {
  return input.map((key, value) {
    if (value is DateTime) {
      return MapEntry(key, value.toIso8601String());
    } else if (value is Map<String, dynamic>) {
      return MapEntry(key, normalizeMap(value));
    } else if (value is List) {
      return MapEntry(
        key,
        value.map((e) {
          if (e is DateTime) return e.toIso8601String();
          if (e is Map<String, dynamic>) return normalizeMap(e);
          return e;
        }).toList(),
      );
    }
    return MapEntry(key, value);
  });
}

  @override
  void onInit() {
    super.onInit();
    fetchFilteredItems();
  }

  Future<void> fetchFilteredItems() async {
    try {
      // Fetch new data first (without setting shimmer)
      final FavoritesModel favoritesModel = await _favoritesApiService.fetchFavorites();

      final List<Map<String, dynamic>> combinedList = [];

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
            'created_at': DateTime.tryParse(news.createdAt ?? '') ?? DateTime.now(),
            'descriptionLinks': news.descriptionLinks,
          });
        }
      }

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
            'created_at': DateTime.tryParse(event.createdAt ?? '') ?? DateTime.now(),
            'descriptionLinks': event.descriptionLinks,
          });
        }
      }

      combinedList.sort((a, b) {
        final aDate = a['created_at'] as DateTime;
        final bDate = b['created_at'] as DateTime;
        return bDate.compareTo(aDate);
      });

      // Check if data changed compared to current
      final bool changed = _hasDataChanged(combinedList);

      if (changed) {
        isLoading.value = true; // Show shimmer only if data changes

        // Small delay to show shimmer smoothly (optional)
        await Future.delayed(const Duration(milliseconds: 300));

        allItems.assignAll(combinedList);
        filteredList.assignAll(combinedList);

        isLoading.value = false;
      } else {
        // Data same - no shimmer, no UI update needed
      }
    } catch (e) {
      print("Error fetching favorites: $e");
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
