import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/apiServices/updates_api_services.dart';
import 'package:kota/model/membership_model.dart';
import 'package:kota/model/updates_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart' as DateUtils;

class UpdateController extends GetxController with WidgetsBindingObserver {
  final UpdateApiService _apiService = UpdateApiService();

  Rx<UpdatesModel?> updatesModel = Rx<UpdatesModel?>(null);
  Rx<MemberShipModel?> memberModel = Rx<MemberShipModel?>(null);
  RxBool isLoadingUpdates = false.obs;
  RxList<Map<String, dynamic>> combinedList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> todayList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> olderList = <Map<String, dynamic>>[].obs;
  RxBool hasNewUpdates = false.obs;
  RxInt newItemsCount = 0.obs;
  RxString searchQuery = ''.obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();

  Timer? _globalTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    getUpdates();

    debounce(
      searchQuery,
      (_) => _applySearch(),
      time: const Duration(milliseconds: 300),
    );

    _startGlobalTimer();
  }

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      getUpdates();
    });
  }

  @override
  void onClose() {
    _globalTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getUpdates(); // Refresh updates when app resumes
    }
  }

  Future<void> getUpdates({bool shouldClear = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString('cached_updates');

    UpdatesModel? cachedModel;
    if (cachedJson != null && cachedJson != "null") {
      final parsed = json.decode(cachedJson);
      if (parsed != null && parsed is Map<String, dynamic>) {
        cachedModel = UpdatesModel.fromJson(parsed);
      }
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
      if (result != null) {
        await prefs.setString('cached_updates', resultJson);
      }

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

  void _processUpdates(UpdatesModel? model) {
    final data = model?.data;
    if (data == null) return;

    final List<Map<String, dynamic>> tempCombined = [];

    // Normalize News
    for (final item in data.news) {
      final parsedDate =
          DateTime.tryParse(item['added_on'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'news',
        'title': item['news_title'] ?? 'No Title',
        'description': item['news_sub_title'] ?? 'No Description',
        'date': parsedDate,
        'news_id': item['news_id'],
      });
    }

    // Normalize Events
    for (final item in data.events) {
      final parsedDate =
          DateTime.tryParse(item['added_on'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'event',
        'title': item['event_name'] ?? 'Event',
        'description': item['event_short_description'] ?? '',
        'date': parsedDate,
        'event_id': item['event_id'],
      });
    }

    // Normalize Threads
    for (final item in data.threads) {
      final parsedDate =
          DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'thread',
        'title': "New Discussion created",
        'description': item['title'] ?? 'Untitled',
        'date': parsedDate,
        'thread_id': item['id'],
      });
    }

    // Normalize Likes on Thread
    for (final item in data.likedMembers) {
      final name = _getFullName(item);
      final rawMessage = item['message'] ?? '$name liked your thread';
      final parsedDate =
          DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'like_post',
        'title': _removeMentionsFromMessage(rawMessage),
        'photo': item['photo'],
        'date': parsedDate,
        'thread_id': item['thread_id'],
      });
    }

    // Normalize Comments on Thread
    for (final item in data.commentedMembers) {
      final name = _getFullName(item);
      final rawMessage = item['message'] ?? '$name commented on your thread';
      final parsedDate =
          DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'comment_post',
        'title': _removeMentionsFromMessage(rawMessage),
        'photo': item['photo'],
        'content': item['content'],
        'date': parsedDate,
        'thread_id': item['thread_id'],
      });
    }

    // Normalize Replies on Comment
    for (final item in data.repliedMembers) {
      final name = _getFullName(item);
      final rawMessage = item['message'] ?? '$name replied to your comment';
      final parsedDate =
          DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'reply_comment',
        'title': _removeMentionsFromMessage(rawMessage),
        'content': item['content'],
        'photo': item['photo'],
        'date': parsedDate,
        'comment_id': item['comment_id'],
        'thread_id': item['thread_id'],
      });
    }

    //Normalize Like on Comment
    for (final item in data.likedComments) {
      final name = _getFullName(item);
      final rawMessage = item['message'] ?? '$name liked your comment';
      final parsedDate =
          DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'like_comment',
        'title': _removeMentionsFromMessage(rawMessage),
        'content': item['content'],
        'photo': item['photo'],
        'date': parsedDate,
        'comment_id': item['comment_id'],
        'thread_id': item['thread_id'],
      });
    }

    // Normalize Poll Created
    for (final item in data.pollCreated) {
      final parsedDate =
          DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
      tempCombined.add({
        'type': 'poll_created',
        'title': "New Poll created",
        'description': item['title'] ?? '',
        'date': parsedDate,
        'poll_id': item['id'],
      });
    }

    // Sort by date (latest first)
    tempCombined.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    // Categorize
    combinedList.value = tempCombined;
    todayList.value =
        tempCombined.where((item) {
          return DateUtils.isSameDay(item['date'] as DateTime, DateTime.now());
        }).toList();

    olderList.value =
        tempCombined.where((item) {
          return !DateUtils.isSameDay(item['date'] as DateTime, DateTime.now());
        }).toList();

    filteredList.value = tempCombined;
  }

  String _removeMentionsFromMessage(String text) {
    final parts = text.split(':');
    if (parts.length < 2) return text;

    final prefix = parts[0]; // e.g., "NAIR commented on your thread"
    final content = parts
        .sublist(1)
        .join(':'); // join in case multiple ':' exist

    final mentionPattern = RegExp(r'@[^@^]+?\^');
    final cleanedContent = content.replaceAll(mentionPattern, '').trim();

    return '$prefix: $cleanedContent';
  }

  String _getFullName(Map<String, dynamic> item) {
    final firstName = item['first_name']?.toString().trim();
    final lastName = item['last_name']?.toString().trim();

    if (firstName != null && firstName.isNotEmpty) {
      return '$firstName ${lastName ?? ''}'.trim();
    }
    return lastName ?? 'Someone';
  }

  Future<void> _handleNewUpdateFlags(
    SharedPreferences prefs,
    bool shouldClear,
  ) async {
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

  bool get isMembershipExpired => memberModel.value?.data?.status == 'expired';

  bool get isMembershipExpiringSoon =>
      memberModel.value?.data?.status == 'expiring_soon';

  String get expiryDateFormatted {
    final date = memberModel.value?.data?.membershipExpiryDate;
    return date != null ? DateFormat('dd MMM yyyy').format(date) : '';
  }

  String get paymentDateFormatted {
    final date = memberModel.value?.data?.paymentDate;
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
