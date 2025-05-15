import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/updates_api_services.dart';
import 'package:kota/model/membership_model.dart';
import 'package:kota/model/updates_model.dart';
import 'package:table_calendar/table_calendar.dart' as DateUtils;

class UpdateController extends GetxController {
  final UpdateApiService _apiService = UpdateApiService();

  Rx<UpdatesModel?> updatesModel = Rx<UpdatesModel?>(null);
  RxBool isLoadingUpdates = false.obs;

  // Final combined list
  RxList<Map<String, dynamic>> combinedList = <Map<String, dynamic>>[].obs;

  // Separated lists
  RxList<Map<String, dynamic>> todayList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> olderList = <Map<String, dynamic>>[].obs;

  RxString searchQuery = ''.obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUpdates();

     debounce(searchQuery, (_) => _applySearch(), time: Duration(milliseconds: 300));
  }

  Future<void> getUpdates() async {
    try {
      isLoadingUpdates.value = true;
      final result = await _apiService.fetchUpdates();
      final memberShip = await _apiService.fetchMembership();
      updatesModel.value = result;

      _processUpdates(result);
    } catch (e) {
      print('Controller error fetching updates: $e');
    } finally {
      isLoadingUpdates.value = false;
    }
  }

  void _processUpdates(UpdatesModel? model) {
  final newsList = model?.data?.news ?? [];
  final eventsList = model?.data?.events ?? [];

  final List<Map<String, dynamic>> tempCombined = [];

  // Normalize News
  for (final item in newsList) {
    final dateStr = item['news_date'] ?? '';
    final parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    tempCombined.add({
      'type': 'news',
      'title': item['news_title'] ?? 'No Title',
      'description': item['news_sub_title'] ?? 'No Description',
      'date': parsedDate,
    });
  }

  // Normalize Events
  for (final item in eventsList) {
    // Adjust the key names based on actual event structure
    String? dateStr;
    String? title;
    String? description;

    if (item is Map<String, dynamic>) {
      dateStr = item['event_date'] ?? ''; // Replace with actual key
      title = item['event_title'] ?? 'Event';
      description = item['event_description'] ?? item.toString();
    } else {
      // fallback for dynamic types (like plain strings)
      dateStr = '';
      title = 'Event';
      description = item.toString();
    }

    final parsedDate = DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
    tempCombined.add({
      'type': 'event',
      'title': title,
      'description': description,
      'date': parsedDate,
    });
  }

  // Sort by newest first
  tempCombined.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

  combinedList.value = tempCombined;

  todayList.value = tempCombined.where((item) {
    final date = item['date'] as DateTime;
    return DateUtils.isSameDay(date, DateTime.now());
  }).toList();

  olderList.value = tempCombined.where((item) {
    final date = item['date'] as DateTime;
    return !DateUtils.isSameDay(date, DateTime.now());
  }).toList();
  filteredList.value = tempCombined;
}

void _applySearch() {
  final query = searchQuery.value.toLowerCase();

  if (query.isEmpty) {
    filteredList.value = combinedList;
  } else {
    filteredList.value = combinedList.where((item) {
      final title = item['title']?.toLowerCase() ?? '';
      final description = item['description']?.toLowerCase() ?? '';
      return title.contains(query) || description.contains(query);
    }).toList();
  }
}

void updateSearch(String value) {
  searchQuery.value = value;
  _applySearch();
}

void clearSearch() {
  searchQuery.value = '';
  searchController.clear();
  _applySearch();
}

@override
void onClose() {
  searchController.dispose();
  super.onClose();
}
}