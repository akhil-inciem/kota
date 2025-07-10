import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/apiServices/events_api_services.dart';
import 'package:kota/apiServices/favorite_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/event_model.dart';

class EventController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<EventsDatum> todayEvents = <EventsDatum>[].obs;
  RxList<EventsDatum> upcomingEvents = <EventsDatum>[].obs;
  final Rx<DateTime> focusedDate = DateTime.now().obs;
  final RxList<EventsDatum> filteredEventsItems = <EventsDatum>[].obs;
  final Rxn<EventsDatum> selectedEvent = Rxn<EventsDatum>();
  final RxInt selectedTabIndex = 0.obs;
  final allEvents = <EventsDatum>[].obs;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;
  RxBool isLoading = false.obs;
  final selectedWeekdayIndex = RxInt(-1);
  var bookmarkedStatus = <String, bool>{}.obs;
  final _favApiService = FavoritesApiService();
  final EventsApiService _eventsApiService = EventsApiService();
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      filterAllEvents(searchController.text);
    });
    
  }

  /// Compare current and new event lists to detect changes
  bool _hasDataChanged(List<EventsDatum> newData) {
    if (allEvents.length != newData.length) return true;

    for (int i = 0; i < newData.length; i++) {
      // Use JSON stringification for deep equality check
      final oldJson = jsonEncode(allEvents[i].toJson());
      final newJson = jsonEncode(newData[i].toJson());
      if (oldJson != newJson) return true;
    }
    return false;
  }

  Future<void> fetchEventItems() async {
    try {
      final fetchedEvents = await _eventsApiService.fetchEvents();
      final reversedEvents = fetchedEvents.reversed.toList();

      // Check if data changed
      final changed = _hasDataChanged(reversedEvents);

      if (changed) {
        isLoading.value = true;

        // Optional small delay for shimmer effect
        await Future.delayed(const Duration(milliseconds: 300));

        allEvents.assignAll(reversedEvents);
        filteredEventsItems.assignAll(reversedEvents);

        isLoading.value = false;
      }
      // else: data unchanged, no shimmer or UI update
    } catch (e) {
      print("Error fetching events: $e");
      isLoading.value = false;
    }
  }

  void toggleBookmark(String id) async {
  final currentStatus = bookmarkedStatus[id] ?? false;
  final newStatus = !currentStatus;

  // Update observable map
  bookmarkedStatus[id] = newStatus;
  bookmarkedStatus.refresh();

  // ✅ Update in allEvents
  final index = allEvents.indexWhere((item) => item.eventId == id);
  if (index != -1) {
    allEvents[index] = allEvents[index].copyWith(
      favorites: newStatus ? 1 : 0,
    );
  }

  // ✅ Update in selectedEvent if currently open
  final selected = selectedEvent.value;
  if (selected != null && selected.eventId == id) {
    selectedEvent.value = selected.copyWith(
      favorites: newStatus ? 1 : 0,
    );
  }

  try {
    await _favApiService.sendEventsBookmarkStatusToApi(id, newStatus);
  } catch (e) {
    print("Failed to update bookmark status: $e");

    // Rollback observable
    bookmarkedStatus[id] = currentStatus;
    bookmarkedStatus.refresh();

    // Rollback model changes
    if (index != -1) {
      allEvents[index] = allEvents[index].copyWith(
        favorites: currentStatus ? 1 : 0,
      );
    }

    if (selected != null && selected.eventId == id) {
      selectedEvent.value = selected.copyWith(
        favorites: currentStatus ? 1 : 0,
      );
    }
  }
}

Future<void> fetchSingleEventItem(String eventId) async {
  final cachedItem = allEvents.cast<EventsDatum?>().firstWhere(
    (item) => item?.eventId == eventId && item?.favorites != null,
    orElse: () => null,
  );

  if (cachedItem != null) {
    selectedEvent.value = cachedItem;
    isLoading.value = false;

    bookmarkedStatus[cachedItem.eventId!] = cachedItem.favorites == 1;
    bookmarkedStatus.refresh();
    return;
  }

  // ❗ API call fallback
  isLoading.value = true;
  selectedEvent.value = null;

  try {
    final eventItem = await _eventsApiService.fetchEventsById(eventsId: eventId);

    if (eventItem != null) {
      selectedEvent.value = eventItem;

      final index = allEvents.indexWhere((item) => item.eventId == eventId);
      if (index != -1) {
        allEvents[index] = eventItem;
        final filteredIndex = filteredEventsItems.indexWhere((item) => item.eventId == eventId);
        if (filteredIndex != -1) {
          filteredEventsItems[filteredIndex] = eventItem;
        }
      } else {
        allEvents.add(eventItem);
        filteredEventsItems.add(eventItem);
      }

      if (eventItem.eventId != null) {
        bookmarkedStatus[eventItem.eventId!] = eventItem.favorites == 1;
        bookmarkedStatus.refresh(); // ✅ Important
      }
    }

    isLoading.value = false;
  } catch (e) {
    print("Error fetching single event item: $e");
  } finally {
    isLoading.value = false;
  }
}


 

  void filterEventsByMonth(DateTime month) {
    todayEvents.clear();
    upcomingEvents.clear();

    for (var event in allEvents) {
      final eventDate = event.eventstartDateDate;
      if (eventDate == null) continue;

      final isSameMonth =
          eventDate.month == month.month && eventDate.year == month.year;

      if (!isSameMonth) continue;

      if (isSameDate(eventDate, selectedDate.value)) {
        todayEvents.add(event);
      } else if (eventDate.isAfter(selectedDate.value)) {
        upcomingEvents.add(event);
      }
    }
  }

  
  void updateSelectedWeekday(DateTime date) {
    selectedWeekdayIndex.value = date.weekday % 7;
  }

  void clearSelectedWeekday() {
    selectedWeekdayIndex.value = -1;
  }

  Future<void> setSelectedDate(DateTime date) async {
    selectedDate.value = date;
    await filterTodayEvents();
  }

  Future<void> filterTodayEvents() async {
    todayEvents.clear();
    upcomingEvents.clear();

    for (var event in allEvents) {
      final eventDate = event.eventstartDateDate;
      if (eventDate == null) continue;

      if (isSameDate(eventDate, selectedDate.value)) {
        todayEvents.add(event);
      } else if (eventDate.isAfter(selectedDate.value)) {
        upcomingEvents.add(event);
      }
    }
  }

  void setFocusedDate(DateTime date) {
    focusedDate.value = date;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
      filteredEventsItems.assignAll(allEvents);
    } else {
      filteredEventsItems.assignAll(
        allEvents.where(
          (item) =>
              item.eventName?.toLowerCase().contains(query.toLowerCase()) ==
                  true 
        ),
      );
    }
  }

  void filterAllEvents(String query) {
    if (query.isEmpty) {
      filteredEventsItems.assignAll(allEvents);
    } else {
      filteredEventsItems.assignAll(
        allEvents.where(
          (item) =>
              item.eventName?.toLowerCase().contains(query.toLowerCase()) ==
              true,
        ),
      );
    }
  }

  void clearSelectedEvent() {
    selectedEvent.value = null;
    bookmarkedStatus.clear();
  }
}
