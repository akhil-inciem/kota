import 'dart:async';

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
import 'package:url_launcher/url_launcher.dart';

class UpdatesScreen extends StatefulWidget {
  UpdatesScreen({Key? key}) : super(key: key);

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen>
    with WidgetsBindingObserver {
  final AuthController authController = Get.find();
  final UpdateController updateController = Get.find();
  late final bool isGuest;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    isGuest = authController.isGuest;

    // Initial load
    updateController.getUpdates(shouldClear: true);

    // Clear flags after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateController.clearNewUpdatesFlag();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateController.getUpdates();
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = updateController.memberModel.value?.data;
    final bool isExpired = item != null &&
        (item.membershipExpiryDate!.isBefore(DateTime.now()) ||
            item.membershipExpiryDate!.isAtSameMomentAs(DateTime.now()));

    return Obx(() {
      final filteredList = updateController.filteredList;

      // Separate filtered list into 'Today' and 'Older'
      final filteredTodayList = filteredList.where((item) {
        final date = item['date'] as DateTime;
        return DateUtils.isSameDay(date, DateTime.now());
      }).toList();

      final filteredOlderList = filteredList.where((item) {
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
              child: updateController.isLoadingUpdates.value
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
                                  color: Color(0xFF0A2C49),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 8.w,
                                height: 2.5.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFF0A57C9),
                                ),
                                child: Center(
                                  child: Text(
                                    "${filteredList.length + (!isGuest && (updateController.isMembershipExpired || updateController.isMembershipExpiringSoon) ? 1 : 0)}",
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
                          child: updateController.isLoadingUpdates.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (!isGuest &&
                                          updateController
                                              .isMembershipExpiringSoon)
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
                                                "Membership Expiring Soon",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(
                                                      0xFFFFA726), // orange
                                                ),
                                              ),
                                              SizedBox(height: 0.5.h),
                                              const Text(
                                                "Your membership is ending soon. Renew now to avoid interruption.",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF69767E),
                                                ),
                                              ),
                                              SizedBox(height: 0.5.h),
                                              Text(
                                                "Expires in ${updateController.daysRemaining} days",
                                                style: const TextStyle(
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
                                                      backgroundColor: const Color(
                                                          0xFFFF9800), // darker orange
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 2.h,
                                                        vertical: 0.3.h,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      const url =
                                                          'https://kbaiota.org/member';
                                                      if (await canLaunchUrl(
                                                          Uri.parse(url))) {
                                                        await launchUrl(
                                                            Uri.parse(url));
                                                      } else {
                                                        throw 'Could not launch $url';
                                                      }
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
                                          filteredOlderList.isEmpty &&
                                          !(!isGuest &&
                                              (updateController
                                                      .isMembershipExpired ||
                                                  updateController
                                                      .isMembershipExpiringSoon)))
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: 25.h,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .notifications_off_outlined,
                                                  size: 30
                                                      .sp, // You can adjust size as needed
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
                                        if (filteredTodayList.isNotEmpty) ...[
                                          sectionHeader("Today"),
                                          ...filteredTodayList.map(
                                            (item) => NotificationTile(
                                              item: {
                                                'title': item['title'],
                                                'description':
                                                    item['description'],
                                                'photo': item['photo'],
                                                'date': item['date'],
                                                'type': item['type'],
                                                "thread_id": item['thread_id'],
                                                'name': item['name'],
                                                'news_id': item['news_id'],
                                                'event_id': item['event_id'],
                                              },
                                            ),
                                          ),
                                        ],
                                        if (filteredOlderList.isNotEmpty) ...[
                                          sectionHeader("Older"),
                                          ...filteredOlderList.map(
                                            (item) => NotificationTile(
                                              item: {
                                                'title': item['title'],
                                                'description':
                                                    item['description'],
                                                'photo': item['photo'],
                                                'date': item['date'],
                                                'type': item['type'],
                                                'name': item['name'],
                                                "thread_id": item['thread_id'],
                                                'news_id': item['news_id'],
                                                'event_id': item['event_id'],
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
