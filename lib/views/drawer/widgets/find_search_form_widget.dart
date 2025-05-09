import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/views/drawer/widgets/custom_expansion_tile.dart';
import 'package:kota/views/drawer/widgets/labelled_dropdown.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchFormWidget extends StatelessWidget {
  final bool isClinic;
  final FindController controller;
  final VoidCallback onSearch;

  const SearchFormWidget({
    super.key,
    required this.isClinic,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: LabelledDropdown(
            label: 'District',
            hintText: "Select a district",
            items: controller.districts,
            selectedValue: controller.selectedDistrict.value,
            onChanged: (val) => controller.selectedDistrict.value = val,
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: LabelledDropdown(
            label: 'Gender',
            hintText: "Select a gender",
            items: controller.genders,
            selectedValue: controller.selectedGender.value,
            onChanged: (val) => controller.selectedGender.value = val,
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: LabelledDropdown(
            label: 'Area of practice',
            hintText: "Select a practice",
            items: controller.practiceAreas,
            selectedValue: controller.selectedPracticeArea.value,
            onChanged: (val) => controller.selectedPracticeArea.value = val,
          ),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: CustomButton(
            text: "Search",
            backgroundColor: AppColors.primaryButton,
            textColor: Colors.white,
            onPressed: onSearch,
          ),
        ),
        SizedBox(height: 3.h),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
