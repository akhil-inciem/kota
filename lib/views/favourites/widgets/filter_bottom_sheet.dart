import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterBottomSheetWidget extends StatelessWidget {
  final FavouriteController favController = Get.find<FavouriteController>();

  FilterBottomSheetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create temp variables locally
    Rx<DateTime?> tempSelectedDate = favController.selectedDate;
    Rx<String?> tempSelectedCategory = favController.selectedCategory;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Date Picker
            InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: tempSelectedDate.value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  tempSelectedDate.value = picked;
                }
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        tempSelectedDate.value != null
                            ? "${tempSelectedDate.value!.day}/${tempSelectedDate.value!.month}/${tempSelectedDate.value!.year}"
                            : "Select Date",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            Obx(
              () => DropdownButtonFormField<String>(
                value: tempSelectedCategory.value,
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text("None"),
                  ),
                  ...DummyData.recommendedItems
                      .map((item) => item['badge'])
                      .toSet()
                      .map((badge) {
                        return DropdownMenuItem<String>(
                          value: badge,
                          child: Text(badge ?? ''),
                        );
                      })
                      .toList(),
                ],
                onChanged: (value) {
                  tempSelectedCategory.value = value;
                },
              ),
            ),
            const SizedBox(height: 30),

            // Apply and Clear buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButton,
                    padding:  EdgeInsets.symmetric(
                      vertical: 1.h,
                      horizontal: 10.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    favController.selectedDate.value = tempSelectedDate.value;
                    favController.selectedCategory.value = tempSelectedCategory.value;
                    favController.applyFilters();
                  },
                  child: const Text("Apply"),
                ),
                if (favController.selectedDate.value != null ||
                    favController.selectedCategory.value != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ElevatedButton(
                      onPressed: favController.resetFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButton,
                        padding:  EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 4.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Clear Filters",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
