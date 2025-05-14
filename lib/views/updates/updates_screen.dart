import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/views/home/widgets/search_bar.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:kota/views/updates/widgets/notification_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdatesScreen extends StatelessWidget {
  UpdatesScreen({Key? key}) : super(key: key);

  final UpdateController controller = Get.put(UpdateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredList = controller.filteredList;

      // Separate filtered list into 'Today' and 'Older'
      final filteredTodayList =
          filteredList.where((item) {
            final date = item['date'] as DateTime;
            return DateUtils.isSameDay(date, DateTime.now());
          }).toList();

      final filteredOlderList =
          filteredList.where((item) {
            final date = item['date'] as DateTime;
            return !DateUtils.isSameDay(date, DateTime.now());
          }).toList();

      return Column(
        children: [
          SizedBox(height: 4.h),
          TopBar(),
          SizedBox(height: 0.5.h),
          CustomSearchBar(
            controller: controller.searchController,
            onChanged: (value) => controller.updateSearch(value),
          ),

          SizedBox(height: 2.h),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child:
                  controller.isLoadingUpdates.value
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "Notifications",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 6.w,
                                  height: 2.5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xFF0A57C9),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${filteredList.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            height: 1,
                          ),

                          // Notification List
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Filtered Today Section (After Search)
                                  if (filteredTodayList.isNotEmpty) ...[
                                    sectionHeader("Today"),
                                    ...filteredTodayList.map(
                                      (item) => NotificationTile(
                                        item: {
                                          'title': item['title'],
                                          'description': item['description'],
                                          'date': item['date'],
                                        },
                                      ),
                                    ),
                                  ],

                                  // Filtered Older Section (After Search)
                                  if (filteredOlderList.isNotEmpty) ...[
                                    sectionHeader("Older"),
                                    ...filteredOlderList.map(
                                      (item) => NotificationTile(
                                        item: {
                                          'title': item['title'],
                                          'description': item['description'],
                                          'date': item['date'],
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        ],
      );
    });
  }

  Widget sectionHeader(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF839099),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
