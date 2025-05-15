import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/views/favourites/widgets/favourite_list.dart';
import 'package:kota/views/favourites/widgets/filter_bottom_sheet.dart';
import 'package:kota/views/home/widgets/news_list.dart';
import 'package:kota/views/home/widgets/search_bar.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteController favController = Get.find<FavouriteController>();

  @override
  void initState() {
    super.initState();
    favController.fetchFilteredItems();
  }

  void openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(),
        SizedBox(height: 0.5.h),
        Row(
          children: [
             Expanded(child: CustomSearchBar(
              controller: favController.searchController,
              onChanged: (value) => favController.setSearchQuery(value),
            )),
            // Filter button
            InkWell(
              onTap: openFilterBottomSheet,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  'assets/icons/Filter.png',
                  width: 4.w,
                  height: 3.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 5.w),
          ],
        ),
        SizedBox(height: 2.h),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 6.w, top: 3.h),
                        child: Row(
                          children: [
                            const Text(
                              "Favourites",
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
                                child: Obx(() {
                                  return Text(
                                    "${favController.filteredList.length}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Divider(color: Colors.grey.shade200, thickness: 1),
                      SizedBox(height: 1.h),
                      SizedBox(
                        height: 62.h,
                        child:
                           FavoriteList(),
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
