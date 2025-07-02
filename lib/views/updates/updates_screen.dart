import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota/controller/auth_controller.dart';
import 'package:kota/controller/updates_controller.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:kota/views/updates/widgets/notification_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class UpdatesScreen extends StatefulWidget {
  UpdatesScreen({Key? key}) : super(key: key);

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  final AuthController authController = Get.find();
  final UpdateController updateController = Get.find();
  late final bool isGuest;

  @override
  void initState() {
    super.initState();
    updateController.getUpdates(shouldClear: true);
    isGuest = authController.isGuest;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateController.clearNewUpdatesFlag();
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = updateController.memberModel.value?.data;
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
                      ? const NotificationShimmer()
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
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  width: 8.w,
                                  height: 2.5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                                                          FontWeight.w600,
                                                      color: Color(0xFFE43434),
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  const Text(
                                                    "Your access has ended. Renew now to keep enjoying your benefits.",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF69767E),
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.5.h),
                                                  Text(
                                                    "Expired on ${DateFormat('dd MMM yyyy').format(item!.membershipExpiryDate!)}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF69767E),
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
                                                              Color(0xFFDD3D3D),
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
                                                        onPressed: () {},
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
                                              filteredOlderList.isEmpty &&
                                              (!isExpired || isGuest))
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 25.h,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .notifications_off_outlined,
                                                      size:
                                                          30.sp, // You can adjust size as needed
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(height: 2.h),
                                                    Text(
                                                      "No notifications available",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
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
                                                    'type':
                                                        item['type'], // 👈 Add type
                                                    'news_id':
                                                        item['news_id'], // 👈 Add news_id
                                                    'event_id':
                                                        item['event_id'], // 👈 Add event_id
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
                                                    'type':
                                                        item['type'], // 👈 Add type
                                                    'news_id':
                                                        item['news_id'], // 👈 Add news_id
                                                    'event_id':
                                                        item['event_id'], // 👈 Add event_id
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class NotificationShimmer extends StatelessWidget {
  final int itemCount;

  const NotificationShimmer({Key? key, this.itemCount = 7}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      itemCount: itemCount,
      itemBuilder: (_, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 50.w, height: 14, color: Colors.white),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
                SizedBox(height: 0.5.h),
                Container(width: 80.w, height: 12, color: Colors.white),
                SizedBox(height: 1.5.h),
                Divider(color: Colors.grey.shade300, thickness: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}
