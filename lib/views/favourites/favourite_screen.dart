import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/favorite_controller.dart';
import 'package:kota/views/favourites/widgets/favourite_list.dart';
import 'package:kota/views/favourites/widgets/filter_bottom_sheet.dart';
import 'package:kota/views/widgets/search_bar.dart';
import 'package:kota/views/widgets/top_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteController favController = Get.put(FavouriteController());

  @override
  void initState() {
    super.initState();
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
      SizedBox(height: 1.h),
      Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              controller: favController.searchController,
              onChanged: (value) => favController.setSearchQuery(value),
            ),
          ),
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
          SizedBox(width: 4.w),
        ],
      ),
      SizedBox(height: 2.h),

      /// ✅ Only one Expanded here wrapping the main scrollable content
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
              Padding(
                padding: EdgeInsets.only(left: 6.w, top: 3.h),
                child: Row(
                  children: [
                     Text(
                      "Favourites",
                      style: TextStyle(
                        fontSize: 15.sp,
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
                        child: Obx(() {
                          return Text(
                            "${favController.filteredList.length}",
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
              Divider(color: Colors.grey.shade200, thickness: 1),
              SizedBox(height: 1.h),
              
              /// ✅ Final Expanded for the scrollable list
              Expanded(
                child: FavoriteList(), // This should be a scrollable widget
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

}
