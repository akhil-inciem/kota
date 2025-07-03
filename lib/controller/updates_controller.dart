import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/apiServices/updates_api_services.dart';
import 'package:kota/model/membership_model.dart';
import 'package:kota/model/updates_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  RxInt newItemsCount = 0.obs;
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

 Future<void> getUpdates({bool shouldClear = false}) async {
  final prefs = await SharedPreferences.getInstance();
  final cachedJson = prefs.getString('cached_updates');

  UpdatesModel? cachedModel;
  if (cachedJson != null) {
    final parsed = json.decode(cachedJson);
    cachedModel = UpdatesModel.fromJson(parsed);
  }

  // Always fetch fresh data
  try {
    final result = await _apiService.fetchUpdates();
    final memberShip = await _apiService.fetchMembership();

    final resultJson = json.encode(result?.toJson());

    // 🔄 Compare current with cached
    if (resultJson == cachedJson) {
      debugPrint('[Updates] Data same as cache. Skipping shimmer.');
      updatesModel.value = result;
      memberModel.value = memberShip;
      _processUpdates(result);

      // Still update new updates flags
      await _handleNewUpdateFlags(prefs, shouldClear);
      return;
    }

    // 🌀 New data: show shimmer
    isLoadingUpdates.value = true;

    // Save new cache
    await prefs.setString('cached_updates', resultJson);

    updatesModel.value = result;
    memberModel.value = memberShip;
    _processUpdates(result);

    await _handleNewUpdateFlags(prefs, shouldClear);
  } catch (e) {
    print('Controller error fetching updates: $e');
  } finally {
    isLoadingUpdates.value = false;
  }
}

Future<void> _handleNewUpdateFlags(
    SharedPreferences prefs, bool shouldClear) async {
  final lastSeenDateStr = prefs.getString('last_seen_update_date');
  DateTime? lastSeenDate =
      lastSeenDateStr != null ? DateTime.tryParse(lastSeenDateStr) : null;

  bool isNewData = false;
  int newCount = 0;

  if (combinedList.isNotEmpty) {
    for (final item in combinedList) {
      final itemDate = item['date'] as DateTime;
      if (lastSeenDate == null || itemDate.isAfter(lastSeenDate)) {
        newCount++;
      }
    }

    final latestDate = combinedList.first['date'] as DateTime;
    if (lastSeenDate == null || latestDate.isAfter(lastSeenDate)) {
      isNewData = true;
    }
  }

  hasNewUpdates.value = isNewData;
  newItemsCount.value = newCount;

  if (shouldClear) clearNewUpdatesFlag();
}



void _processUpdates(UpdatesModel? model) {
  final newsList = model?.data?.news ?? [];
  final eventsList = model?.data?.events ?? [];

  final List<Map<String, dynamic>> tempCombined = [];

  // Normalize News
  for (final item in newsList) {
    final dateStr = item['added_on'] ?? '';
    final parsedDate = DateTime.tryParse(dateStr) ?? DateTime.now();
    tempCombined.add({
      'type': 'news',
      'title': item['news_title'] ?? 'No Title',
      'description': item['news_sub_title'] ?? 'No Description',
      'date': parsedDate,
      'news_id': item['news_id'], // ✅ Include news_id
    });
  }

  // Normalize Events
  for (final item in eventsList) {
    String? dateStr;
    String? title;
    String? description;
    String? eventId;

    if (item is Map<String, dynamic>) {
      dateStr = item['added_on'] ?? '';
      title = item['event_name'] ?? 'Event';
      description = item['event_short_description'] ?? item.toString();
      eventId = item['event_id']; // ✅ Include event_id
    } else {
      dateStr = '';
      title = 'Event';
      description = item.toString();
      eventId = null;
    }

    final parsedDate = DateTime.tryParse(dateStr ?? '') ?? DateTime.now();
    tempCombined.add({
      'type': 'event',
      'title': title,
      'description': description,
      'date': parsedDate,
      'event_id': eventId, // ✅ Include event_id
    });
  }

  tempCombined.sort(
    (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
  );

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

bool get isMembershipExpired =>
    memberModel.value?.data?.status == 'expired';

bool get isMembershipExpiringSoon =>
    memberModel.value?.data?.status == 'expiring_soon';

String get expiryDateFormatted {
  final date = memberModel.value?.data?.membershipExpiryDate;
  return date != null ? DateFormat('dd MMM yyyy').format(date) : '';
}

num get daysRemaining => memberModel.value?.data?.daysRemaining ?? 0;
num get daysExpired => memberModel.value?.data?.daysExpired ?? 0;


void clearNewUpdatesFlag() {
  hasNewUpdates.value = false;

  // Save latest date to prefs
  if (combinedList.isNotEmpty) {
    final latestDate = combinedList.first['date'] as DateTime;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('last_seen_update_date', latestDate.toIso8601String());
    });
  }
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
