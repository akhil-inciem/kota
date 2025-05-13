import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota/controller/find_controller.dart' show FindController;
import 'package:kota/views/drawer/find/widgets/find_search_form_widget.dart';
import 'package:kota/views/drawer/find/widgets/find_search_result_widget.dart';

class FindTherapistTab extends StatelessWidget {
  final FindController controller;

  const FindTherapistTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isTherapistLoading.value;
      final isSearched = controller.isTherapistSearched.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (isSearched) {
        return SearchResultTherapistWidget(
          onSearch: controller.filterTherapists,
          results: controller.filteredTherapistList.toList(),
          onReset: () => controller.resetTherapistSearch(),
        );
      }

      return SearchFormWidget(
        controller: controller,
        onSearch: () => controller.findTherapist(),
      );
    });
  }
}
