import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/updates_api_services.dart';
import 'package:kota/model/membership_model.dart';
import 'package:kota/model/updates_model.dart';
import 'package:table_calendar/table_calendar.dart' as DateUtils;

class UpdateController extends GetxController {
  final UpdateApiService _apiService = UpdateApiService();

  Rx<UpdatesModel?> updatesModel = Rx<UpdatesModel?>(null);
  Rx<MemberShipModel?> memberModel = Rx<MemberShipModel?>(null);
  RxBool isLoadingUpdates = false.obs;
  RxList<Map<String, dynamic>> combinedList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> todayList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> olderList = <Map<String, dynamic>>[].obs;
  RxBool hasNewUpdates = false.obs;
  DateTime? _latestFetchedDate;
  RxString searchQuery = ''.obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getUpdates();
    debounce(
      searchQuery,
      (_) => _applySearch(),
      time: Duration(milliseconds: 300),
    );
  }

  Future<void> getUpdates() async {
  try {
    isLoadingUpdates.value = true;
    final result = await _apiService.fetchUpdates();
    final memberShip = await _apiService.fetchMembership();
    updatesModel.value = result;
    memberModel.value = memberShip;

    bool isNewData = _checkForNewData(result);
    if (isNewData) {
      hasNewUpdates.value = true;
    }

    _processUpdates(result);
  } catch (e) {
    print('Controller error fetching updates: $e');
  } finally {
    isLoadingUpdates.value = false;
  }
}

bool _checkForNewData(UpdatesModel? model) {
  final newsList = model?.data?.news ?? [];
  final eventsList = model?.data?.events ?? [];

  final allDates = [
    ...newsList.map((e) => DateTime.tryParse(e['news_date'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0)),
    ...eventsList.map((e) => DateTime.tryParse(e['event_date'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0)),
  ];

  if (allDates.isEmpty) return false;

  allDates.sort((a, b) => b.compareTo(a));  // Latest date at top
  final latestDate = allDates.first;

  if (_latestFetchedDate == null || latestDate.isAfter(_latestFetchedDate!)) {
    _latestFetchedDate = latestDate;
    return true;
  }

  return false;
}

void clearNewUpdatesFlag() {
  hasNewUpdates.value = false;
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
        'title': item['news_name'] ?? 'No Title',
        'description': item['news_sub_title'] ?? 'No Description',
        'date': parsedDate,
      });
    }
    for (final item in eventsList) {
      String? dateStr;
      String? title;
      String? description;

      if (item is Map<String, dynamic>) {
        dateStr = item['eventstart_date_date'] ?? '';
        title = item['event_name'] ?? 'Event';
        description = item['event_description'] ?? item.toString();
      } else {
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
    tempCombined.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );
    combinedList.value = tempCombined;
    todayList.value =
        tempCombined.where((item) {
          final date = item['date'] as DateTime;
          return DateUtils.isSameDay(date, DateTime.now());
        }).toList();
    olderList.value =
        tempCombined.where((item) {
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
      filteredList.value =
          combinedList.where((item) {
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
}
