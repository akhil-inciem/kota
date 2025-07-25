import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/event_controller.dart';
import 'package:kota/controller/home_controller.dart';
import 'package:kota/controller/user_controller.dart';
import 'package:kota/views/home/widgets/events_list.dart';
import 'package:kota/views/home/widgets/home_tab_bar.dart';
import 'package:kota/views/home/widgets/advertisement_list.dart';
import 'package:kota/views/home/widgets/news_list.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final EventController eventController = Get.put(EventController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    homeController.fetchNewsItems();
    eventController.fetchEventItems();
    userController.loadUserProfile();
    homeController.loadAdvertisements();
    eventController.filterTodayEvents();
    homeController.searchController.addListener(() {
      homeController.filterNews(homeController.searchController.text);
      eventController.filterEvents(homeController.searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        SizedBox(height: 1.h),
        CustomSearchBar(
          controller: homeController.searchController,
          onChanged: (value) {
            homeController.selectedTabIndex.value == 0
                ? homeController.filterNews(value)
                : eventController.filterEvents(value);
          },
        ),
        SizedBox(height: 1.h),
        Obx(() {
          return HomeTabBar(
            selectedIndex: homeController.selectedTabIndex.value,
            onTabSelected: (index) {
              homeController.searchController.clear();
              homeController.selectedTabIndex.value = index;
            },
          );
        }),
        Expanded(
          child: Stack(
            children: [
              // Advertisement list at the bottom
              AdvertisementList(),

              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 1.0,
                  builder: (
                    BuildContext context,
                    ScrollController scrollController,
                  ) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(11.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.w, top: 1.h),
                              child: Row(
                                children: [
                                  Text(
                                    "Recommended",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0A2C49)
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 8.w,
                                    height: 2.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xFF0A57C9),
                                    ),
                                    child: Center(
                                      child: Obx(() {
                                        return Text(
                                          homeController
                                                      .selectedTabIndex
                                                      .value ==
                                                  0
                                              ? homeController
                                                  .filteredNewsItems
                                                  .length
                                                  .toString()
                                              : eventController
                                                  .filteredEventsItems
                                                  .length
                                                  .toString(),
                                          // "678",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Obx(() {
                              return Expanded(
                                child:
                                    homeController.selectedTabIndex.value == 0
                                        ? NewsList(
                                          isFavourite: false,
                                          scrollController: scrollController,
                                        )
                                        : EventsList(
                                          isFavourite: false,
                                          scrollController: scrollController,
                                        ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
