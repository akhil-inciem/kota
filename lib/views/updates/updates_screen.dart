import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:kota/views/updates/widgets/notification_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdatesScreen extends StatelessWidget {
  UpdatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final updateController = Get.find<UpdateController>();
    final item = updateController.memberModel.value?.data;
    final isGuest = authController.isGuest;

    final bool isExpired =
        item != null &&
        (item.membershipExpiryDate!.isBefore(DateTime.now()) ||
            item.membershipExpiryDate!.isAtSameMomentAs(DateTime.now()));

    return Obx(() {
      final filteredList = updateController.filteredList;

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
          TopBar(),
          SizedBox(height: 0.5.h),
          CustomSearchBar(
            controller: updateController.searchController,
            onChanged: (value) => updateController.updateSearch(value),
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
                  updateController.isLoadingUpdates.value
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
                            child:
                                updateController.isLoadingUpdates.value
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!isGuest && isExpired)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6.w,
                                                vertical: 1.h,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Membership Expired!",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  const Text(
                                                    "Your access has ended. Renew now to keep enjoying your benefits.",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  Text(
                                                    "Expired on ${DateFormat('dd MMM yyyy').format(item!.membershipExpiryDate!)}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 10,
                                                              ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          // Trigger renew logic
                                                        },
                                                        child: const Text(
                                                          "Renew Membership",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                          // Now check for notifications
                                          if (filteredTodayList.isEmpty &&
                                              filteredOlderList.isEmpty)
                                             Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 30.h,
                                                ),
                                                child: Text(
                                                  "No notifications found",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                          else ...[
                                            if (filteredTodayList
                                                .isNotEmpty) ...[
                                              sectionHeader("Today"),
                                              ...filteredTodayList.map(
                                                (item) => NotificationTile(
                                                  item: {
                                                    'title': item['title'],
                                                    'description':
                                                        item['description'],
                                                    'date': item['date'],
                                                  },
                                                ),
                                              ),
                                            ],
                                            if (filteredOlderList
                                                .isNotEmpty) ...[
                                              sectionHeader("Older"),
                                              ...filteredOlderList.map(
                                                (item) => NotificationTile(
                                                  item: {
                                                    'title': item['title'],
                                                    'description':
                                                        item['description'],
                                                    'date': item['date'],
                                                  },
                                                ),
                                              ),
                                            ],
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
