import 'package:get/get.dart';
import 'package:kota/apiServices/events_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/event_model.dart';

class EventController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Datum> todayEvents = <Datum>[].obs;
  RxList<Datum> upcomingEvents = <Datum>[].obs;
  final Rx<DateTime> focusedDate = DateTime.now().obs;
  final allEvents = <Datum>[].obs;
  RxBool isLoading = false.obs;
  final selectedWeekdayIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchEventItems();
    await filterEvents(); // 👈 Ensure events are filtered only after fetching
  }

  Future<void> fetchEventItems() async {
    isLoading.value = true;
    try {
      EventsModel events = EventsModel.fromJson(DummyData.events);
      // final fetchedEvents = await EventsApiService().fetchEvents();
      allEvents.assignAll(events.data);
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
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
    await filterEvents();
  }

  Future<void> filterEvents() async {
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
}
