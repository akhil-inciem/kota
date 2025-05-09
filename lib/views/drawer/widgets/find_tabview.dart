import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/find_controller.dart' show FindController;
import 'package:kota/views/drawer/widgets/find_search_form_widget.dart';
import 'package:kota/views/drawer/widgets/find_search_result_widget.dart';

class FindTab extends StatelessWidget {
  final bool isClinic;
  final FindController controller;

  const FindTab({super.key, required this.isClinic, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = isClinic ? controller.isClinicLoading.value : controller.isTherapistLoading.value;
      final isSearched = isClinic ? controller.isClinicSearched.value : controller.isTherapistSearched.value;
      final results = isClinic ? controller.clinicResults : controller.therapistResults;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (isSearched) {
        return SearchResultsWidget(
          isClinic: isClinic,
          results: results,
          onReset: () => controller.resetSearch(isClinic: isClinic),
        );
      }

      return SearchFormWidget(
        isClinic: isClinic,
        controller: controller,
        onSearch: () => controller.performSearch(isClinic: isClinic),
      );
    });
  }
}
