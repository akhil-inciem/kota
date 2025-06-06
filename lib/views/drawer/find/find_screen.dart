import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/views/drawer/find/widgets/find_clinic_tab.dart';
import 'package:kota/views/drawer/find/widgets/find_therapist_tab.dart';
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
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // Delay reactive value assignment until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isTherapistSearched.value = false;
      controller.isClinicSearched.value = false;
    });
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              _buildAppBar(),
              SizedBox(height: 2.h),
              Container(
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
              Expanded(
                child: Obx(() {
                  if (!controller.isDropdownDataLoaded.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      FindTherapistTab(controller: controller),
                      FindClinicTab(controller: controller),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Image.asset(
            'assets/icons/backbutton.png',
            color: Colors.black,
            width: 6.w,
            height: 2.5.h,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          "Find",
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
