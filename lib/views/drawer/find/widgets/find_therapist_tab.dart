import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/find_controller.dart' show FindController;
import 'package:kota/views/drawer/find/therapist_list_screen.dart';
import 'package:kota/views/drawer/find/widgets/find_search_form_widget.dart';
import 'package:kota/views/drawer/find/widgets/find_search_result_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FindTherapistTab extends StatelessWidget {
  final FindController controller;

  const FindTherapistTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isTherapistLoading.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return Container(
        color: Colors.white,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 4.w),
          child: SearchFormWidget(
            controller: controller,
            onSearch: () {
              controller.findTherapist();
              Get.to(() => TherapistResultsScreen(controller: controller));
            },
          ),
        ),
      );
    });
  }
}
