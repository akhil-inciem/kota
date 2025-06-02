import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kota/apiServices/drawer_api_services.dart';
import 'package:kota/model/executive_model.dart';
import 'package:kota/model/faq_model.dart';
import 'package:kota/model/vision_mission_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
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
    loadFaqs();
  fetchVisionAndMission();
  fetchExecutives();
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

  // Step 1: Request proper permissions
  if (Platform.isAndroid) {
    if (await Permission.storage.isDenied || await Permission.storage.isPermanentlyDenied) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        CustomSnackbars.failure('Storage permission is required to download.', 'Permission Denied');
        isDownloading.value = false;
        return;
      }
    }
  }

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download file');
    }

    // Step 2: Choose a safe directory
    Directory? directory;
    if (Platform.isAndroid) {
      // For Android 11+ we use getExternalStorageDirectory
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('Unable to get download directory');
    }

    // Step 3: Save the file
    final fileName = 'downloaded_file_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    CustomSnackbars.success('Saved to ${directory.path}', 'Download Complete');

    // Optional: Open the file
    // await OpenFile.open(filePath);

  } catch (e) {
    CustomSnackbars.failure('Download failed: $e', 'Error');
  } finally {
    isDownloading.value = false;
  }
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
