import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/views/drawer/widgets/custom_expansion_tile.dart';
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
  bool _isTermsAccepted = false;

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
            TopBar(title: "Find",onTap: ()=> Get.back(),),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                color: AppColors.primaryBackground,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primaryText,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryText,
                      indicatorWeight: 4.0,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 2.w),
                      tabs: [Tab(text: 'Find a Therapist'), Tab(text: 'Find Clinic')],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildForm(isStudent: false),
                  _buildForm(isStudent: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm({required bool isStudent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w), // Horizontal padding for these widgets
          child: LabelledTextField(
            label: 'Email',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w), // Horizontal padding for these widgets
          child: LabelledTextField(
            label: 'Mobile Number',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w), // Horizontal padding for these widgets
          child: LabelledTextField(
            label: 'First Name',
            hintText: 'Select a value',
            icon: Icons.person,
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w), // Horizontal padding for these widgets
          child: CustomButton(
            text: "Search",
            backgroundColor: AppColors.primaryButton,
            textColor: Colors.white,
          ),
        ),
        SizedBox(height: 3.h),
        // Wrapping the container with SingleChildScrollView
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(2.h), // No horizontal padding here
              child: Column(
                children: [
                  CustomExpansionTile(
                    title: 'Points to Check Before Contacting an Occupational Therapist',
                    options: ['Option 1', 'Option 2'],
                  ),
                  CustomExpansionTile(
                    title: 'Know Your Professional',
                    options: ['Item A', 'Item B', 'Item C'],
                  ),
                  CustomExpansionTile(
                    title: 'Questions to Ask an Occupational Therapist When You Contact Them',
                    options: ['Apple', 'Banana', 'Cherry'],
                  ),
                  SizedBox(height: 4          .h,)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
