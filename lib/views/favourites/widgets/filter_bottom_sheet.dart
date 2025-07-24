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
        left: 2.h,
        right: 2.h,
        top: 2.h,
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
                  padding:  EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                       Icon(Icons.calendar_today, size: 18.sp),
                       SizedBox(width: 1.h),
                      Text(
                        tempSelectedDate.value != null
                            ? "${tempSelectedDate.value!.day}/${tempSelectedDate.value!.month}/${tempSelectedDate.value!.year}"
                            : "Select Date",
                            style: TextStyle(fontSize: 15.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             SizedBox(height: 2.h),

            // Category Dropdown
            Obx(
              () => DropdownButtonFormField<String>(
                value: tempSelectedCategory.value,
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical:
                        2.5.h, // 👈 Increase this for more vertical space inside field
                    horizontal: 4.w, // Optional: control side padding
                  ),
                ),
                
                items: [
                   DropdownMenuItem<String>(
                    value: null,
                    child: Text("None",
                    style: TextStyle(fontSize: 13.5.sp),
                    ),
                  ),
                  ...DummyData.recommendedItems
                      .map((item) => item['badge'])
                      .toSet()
                      .map((badge) {
                        return DropdownMenuItem<String>(
                          value: badge,
                          child: Text(badge ?? '',
                          style: TextStyle(fontSize: 13.5.sp),
                          ),
                        );
                      })
                      .toList(),
                ],
                onChanged: (value) {
                  tempSelectedCategory.value = value;
                },
              ),
            ),
             SizedBox(height: 3.h),

            // Apply and Clear buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (favController.selectedDate.value != null ||
                    favController.selectedCategory.value != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ElevatedButton(
                      onPressed: favController.resetFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
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
                
              ],
            ),
             SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
