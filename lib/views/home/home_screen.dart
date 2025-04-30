import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/home/widgets/custom_bottom_nav_bar.dart';
import 'package:kota/views/home/widgets/home_tab_bar.dart';
import 'package:kota/views/home/widgets/latest_news_list.dart';
import 'package:kota/views/home/widgets/recommended_list.dart';
import 'package:kota/views/home/widgets/search_bar.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4.h),
         TopBar(guest: true),
        SizedBox(height: 0.5.h),
        const CustomSearchBar(),
        SizedBox(height: 2.h),
        const HomeTabBar(),
        Expanded(
          child: Stack(
            children: [
              // Advertisement list at the bottom
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  AdvertisementList(),
                ],
              ),
              // DraggableScrollableSheet on top of the advertisement list
              Positioned.fill(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.7, // Initial size of the sheet
                  minChildSize: 0.7, // Minimum size when dragged down
                  maxChildSize: 1.0, // Maximum size when fully dragged up
                  builder: (BuildContext context, ScrollController scrollController) {
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    width: 10.w,
                                    height: 2.5.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0xFF0A57C9),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "250",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),
                            // Recommended list with scroll controller
                            
                            Expanded(
                              child: RecommendedList(
                                  isFavourite: false,
                                  scrollController: scrollController,
                                ),
                            ),
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
