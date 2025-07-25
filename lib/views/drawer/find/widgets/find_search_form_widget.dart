import 'package:flutter/material.dart';
import 'package:kota/constants/colors.dart';
import 'package:kota/controller/find_controller.dart';
import 'package:kota/model/therapist_dropdwon_model.dart';
import 'package:kota/views/drawer/find/widgets/expansion_tile_group.dart';
import 'package:kota/views/drawer/widgets/custom_expansion_tile.dart';
import 'package:kota/views/drawer/widgets/labelled_dropdown.dart';
import 'package:kota/views/login/widgets/custom_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchFormWidget extends StatelessWidget {
  final FindController controller;
  final VoidCallback onSearch;

  const SearchFormWidget({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          LabelledDropdown<District>(
            label: 'District',
            hintText: "Select a district",
            items: controller.districts,
            selectedValue: controller.selectedDistrict.value,
            itemAsString: (district) => district.district ?? '',
            onChanged: (val) => controller.selectedDistrict.value = val,
          ),
          SizedBox(height: 2.h),
          LabelledDropdown<Gender>(
            label: 'Gender',
            hintText: "Select a gender",
            items: controller.genders,
            selectedValue: controller.selectedGender.value,
            onChanged: (val) => controller.selectedGender.value = val,
            itemAsString: (gender) => gender.gender ?? '',
          ),
          SizedBox(height: 2.h),
          LabelledDropdown<PracticeArea>(
            label: 'Area of practice',
            hintText: "Select a practice",
            items: controller.practiceAreas,
            selectedValue: controller.selectedPracticeArea.value,
            onChanged: (val) => controller.selectedPracticeArea.value = val,
            itemAsString: (practiceArea) => practiceArea.specialization ?? '',
          ),
          SizedBox(height: 4.h),
          CustomButton(
            text: "Search",
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
            onPressed: onSearch,
          ),
          SizedBox(height: 3.h),
          ExpansionTileGroup()
        ],
      ),
    );
  }
}
