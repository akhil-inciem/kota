import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/views/drawer/widgets/custom_expansion_tile.dart';
import 'package:kota/views/drawer/widgets/find_tabview.dart';
import 'package:kota/views/drawer/widgets/labelled_dropdown.dart';
import 'package:kota/views/home/widgets/top_bar.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:kota/views/login/widgets/custom_checkbox.dart';
import 'package:kota/views/login/widgets/labelled_textfield.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FindScreen extends StatefulWidget {
  const FindScreen({Key? key}) : super(key: key);

  @override
  State<FindScreen> createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FindController controller = Get.put(FindController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            TopBar(title: "Find", onTap: () => Get.back()),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                color: AppColors.primaryBackground,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primaryText,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primaryText,
                  indicatorWeight: 4.0,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 2.w),
                  tabs: [
                    Tab(text: 'Find a Therapist'),
                    Tab(text: 'Find Clinic'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FindTab(isClinic: false, controller: controller),
                  FindTab(isClinic: true, controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

