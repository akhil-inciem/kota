import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/views/home/widgets/recommended_list.dart';
import 'package:kota/views/home/widgets/search_bar.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:kota/views/updates/widgets/notification_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdatesScreen extends StatelessWidget {
  UpdatesScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> notifications = DummyData.recommendedItems;

  @override
  Widget build(BuildContext context) {
    // Split notifications into Today and Older
    final today = notifications.where((item) {
      final date = item['date'] as DateTime?;
      return date != null && DateUtils.isSameDay(date, DateTime.now());
    }).toList();

    final older = notifications.where((item) {
      final date = item['date'] as DateTime?;
      return !(date != null && DateUtils.isSameDay(date, DateTime.now()));
    }).toList();

    return Column(
  children: [
    SizedBox(height: 4.h),
    TopBar(),
    SizedBox(height: 0.5.h),
    CustomSearchBar(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed Notification Title
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  child: Row(
                    children: [
                      const Text(
                        "Notification",
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
                            "${notifications.length}",
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
              ],
            ),

            // Scrollable notification list
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODAY Section
                    if (today.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
                          child: Text(
                            "Today",
                            style: TextStyle(
                              color: Color(0xFF839099),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      ...today.map((item) => NotificationTile(item: item)).toList(),
                    ],

                    // OLDER Section
                    if (older.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
                          child: Text(
                            "Older",
                            style: TextStyle(
                              color: Color(0xFF839099),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ...older.map((item) => NotificationTile(item: item)).toList(),
                      SizedBox(height: 1.h),
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
  }
}

class NotificationTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const NotificationTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime? date = item['date'];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Container(
            padding: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          item['title'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          item['description'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (date != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD3D8FF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  DateFormat('dd MMM yyyy').format(date),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF2640C8),
                                  ),
                                ),
                              ),
                            if (item['actionText'] != null)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDD3D3D),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item['actionText'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h,),
                      Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
