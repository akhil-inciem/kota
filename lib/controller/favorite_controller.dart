import 'package:get/get.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/data/dummy.dart';

import 'package:get/get.dart';
import 'package:kota/model/favorite_model.dart';

class FavouriteController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<String?> selectedCategory = Rx<String?>(null);
  final isLoading = true.obs;

  final allItems = <Map<String, dynamic>>[].obs; // Stores all news + events
  final filteredList = <Map<String, dynamic>>[].obs;
  final FavoritesApiService _favoritesApiService = FavoritesApiService();

  @override
  void onInit() {
    super.onInit();
    fetchFilteredItems();
  }

  Future<void> fetchFilteredItems() async {
    try {
      isLoading.value = true;

      FavoritesModel favoritesModel = await _favoritesApiService.fetchFavorites();

      final List<Map<String, dynamic>> combinedList = [];

      // Combine news
      if (favoritesModel.data?.news != null) {
        for (var news in favoritesModel.data!.news!) {
          combinedList.add({
            'type': 'news',
            'title': news.newsTitle ?? '',
            'description': news.newsDescription ?? '',
            'date': DateTime.tryParse(news.newsDate ?? '') ?? DateTime.now(),
            'badge': news.badges ?? '',
            'image': news.newsImage ?? '',
            'data': news,
          });
        }
      }

      // Combine events
      if (favoritesModel.data?.events != null) {
        for (var event in favoritesModel.data!.events!) {
          combinedList.add({
            'type': 'event',
            'title': event.eventName ?? '',
            'description': event.eventDescription ?? '',
            'date': DateTime.tryParse(event.eventstartDateDate ?? '') ?? DateTime.now(),
            'badge': event.badges ?? '',
            'image': event.image ?? '',
            'data': event,
          });
        }
      }

      allItems.value = combinedList;
      filteredList.value = combinedList;
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

      if (selectedDate.value != null) {
        DateTime itemDate = item['date'];
        matchesDate = itemDate.year == selectedDate.value!.year &&
                      itemDate.month == selectedDate.value!.month &&
                      itemDate.day == selectedDate.value!.day;
      }

      if (selectedCategory.value != null && selectedCategory.value != 'None') {
        matchesCategory = item['badge'] == selectedCategory.value;
      }

      return matchesDate && matchesCategory;
    }).toList();
  }

  void resetFilters() {
    selectedDate.value = null;
    selectedCategory.value = null;
    filteredList.value = allItems;
  }

  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;
  }

  void setSelectedCategory(String? category) {
    selectedCategory.value = category;
  }
}
