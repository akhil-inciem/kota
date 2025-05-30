import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kota/apiServices/drawer_api_services.dart';
import 'package:kota/apiServices/events_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/event_model.dart';
import 'package:kota/model/executive_model.dart';
import 'package:kota/model/faq_model.dart';
import 'package:kota/model/vision_mission_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class SideMenuController extends GetxController {
  final executiveList = <LeadersDetail>[].obs;
  final visionMission = <VisionDatum>[].obs;
  RxBool isLoading = false.obs;
  RxList<AbMemberFaq> faqList = <AbMemberFaq>[].obs;
  final DrawerApiServices _drawerApiServices = DrawerApiServices();
  RxInt expandedIndex = (-1).obs;
  var isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchExecutives() async {
    isLoading.value = true;
    try {
      final fetchedExecutives = await _drawerApiServices.fetchExecutives();
      if (!listEquals(fetchedExecutives, executiveList)) {
        executiveList.assignAll(fetchedExecutives);
      }
    } catch (e) {
      print("Error fetching executives: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadPdf(String url) async {
    if (isDownloading.value) return;

    isDownloading.value = true;

    final status = await Permission.storage.request();

    if (status.isGranted) {
      try {
        final response = await http.get(Uri.parse(url));
        final directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final fileName = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        CustomSnackbars.success('Saved to Downloads', 'Download Complete');
      } catch (e) {
        CustomSnackbars.failure('Download failed: $e', 'Error');
      }
    } else {
      CustomSnackbars.failure('Storage permission is required to download.', 'Permission Denied');
    }
    isDownloading.value = false;
  }

  void toggleExpansion(int index) {
    expandedIndex.value = index;
  }

  Future<void> loadFaqs() async {
    isLoading.value = true;
    try {
      final fetchedFaqs = await _drawerApiServices.fetchMemberFaqs();
      if (!listEquals(fetchedFaqs, faqList)) {
        faqList.assignAll(fetchedFaqs);
      }
    } catch (e) {
      CustomSnackbars.failure(
        'Something went wrong while fetching the FAQ list. Please try again later.',
        'Failed to Load FAQs',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVisionAndMission() async {
    isLoading.value = true;
    try {
      final fetchedVisionInfo =
          await _drawerApiServices.fetchVisionAndMission();
      if (!listEquals(fetchedVisionInfo, visionMission)) {
        visionMission.assignAll(fetchedVisionInfo);
      }
    } catch (e) {
      print("Error fetching vision/mission: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
