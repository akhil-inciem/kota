import 'package:get/get.dart';
import 'package:kota/data/dummy.dart';

class FavouriteController extends GetxController {
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<String?> selectedCategory = Rx<String?>(null);
  final isLoading = true.obs;
  final filteredList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilteredItems();
  }

  Future<void> fetchFilteredItems() async {
    isLoading.value = true;
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    // Replace this with your actual API datas
    filteredList.value = DummyData.recommendedItems;
    isLoading.value = false;
  }

  void applyFilters() {
    filteredList.value = DummyData.recommendedItems.where((item) {
      bool matchesDate = true;
      bool matchesCategory = true;

      if (selectedDate.value != null) {
  DateTime itemDate = item['date']!;
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
    filteredList.value = DummyData.recommendedItems;
  }

  // Set the date filter
  void setSelectedDate(DateTime? date) {
    selectedDate.value = date;
  }

  // Set the category filter
  void setSelectedCategory(String? category) {
    selectedCategory.value = category;
  }
}
