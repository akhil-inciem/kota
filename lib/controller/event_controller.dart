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



  Future<void> fetchEventItems() async {
  isLoading.value = true;
  try {
    final fetchedEvents = await _eventsApiService.fetchEvents();
    final reversedEvents = fetchedEvents.reversed.toList();
    allEvents.assignAll(reversedEvents);
    filteredEventsItems.assignAll(reversedEvents);
  } catch (e) {
    print("Error fetching events: $e");
  } finally {
    isLoading.value = false;
  }
}


  Future<void> fetchSingleEventItem(String eventId) async {
    isLoading.value = true;
    selectedEvent.value = null;

    try {
      final eventItem = await _eventsApiService.fetchEventsById(
        eventsId: eventId,
      );

      if (eventItem != null) {
        selectedEvent.value = eventItem;
        final index = allEvents.indexWhere((item) => item.eventId == eventId);
        if (index != -1) {
          allEvents[index] = eventItem;
          filteredEventsItems[index] = eventItem;
        } else {
          allEvents.add(eventItem);
          filteredEventsItems.add(eventItem);
        }
        if (eventItem.eventId != null) {
          bookmarkedStatus[eventItem.eventId!] = eventItem.favorites == 1;
        }
      }
    } catch (e) {
      print("Error fetching single news item: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleBookmark(String id) async {
    final currentStatus = bookmarkedStatus[id] ?? false;
    final newStatus = !currentStatus;
    bookmarkedStatus[id] = newStatus;
    try {
      await _favApiService.sendEventsBookmarkStatusToApi(id, newStatus);
    } catch (e) {
      print("Failed to update bookmark status: $e");
      bookmarkedStatus[id] = currentStatus;
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
                  true ||
              item.eventDescription?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ==
                  true,
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
                  true 
        ),
      );
    }
  }
  void clearSelectedEvent() {
  selectedEvent.value = null;
  bookmarkedStatus.clear();
}

}
