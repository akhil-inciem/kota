import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kota/apiServices/drawer_api_services.dart';
import 'package:kota/model/colleges_model.dart';
import 'package:kota/model/executive_model.dart';
import 'package:kota/model/faq_model.dart';
import 'package:kota/model/vision_mission_model.dart';
import 'package:kota/views/widgets/custom_snackbar.dart';

class SideMenuController extends GetxController {
  final executiveList = <LeadersDetail>[].obs;
  final visionMission = <VisionDatum>[].obs;
  RxBool isLoading = false.obs;
  RxList<AbMemberFaq> faqList = <AbMemberFaq>[].obs;
  List<OtCollegesKerala> allKeralaColleges = [];
List<OtCollegesKerala> allNonKeralaColleges = [];
  RxList<OtCollegesKerala> keralaColleges = <OtCollegesKerala>[].obs;
  RxList<OtCollegesKerala> nonKeralaColleges = <OtCollegesKerala>[].obs; 
  final DrawerApiServices _drawerApiServices = DrawerApiServices();
  RxInt expandedIndex = (-1).obs;
  final TextEditingController searchController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    loadFaqs();
  fetchVisionAndMission();
  fetchExecutives();
  loadColleges();
  }

  void filterColleges(bool isKerala) {
    final query = searchController.text.toLowerCase();
    if (isKerala) {
      keralaColleges.assignAll(
        allKeralaColleges.where((c) => c.collegeName.toLowerCase().contains(query)),
      );
    } else {
      nonKeralaColleges.assignAll(
        allNonKeralaColleges.where((c) => c.collegeName.toLowerCase().contains(query)),
      );
    }
  }

  void clearSearch(bool isKerala) {
    searchController.clear();
    if (isKerala) {
      keralaColleges.assignAll(allKeralaColleges);
    } else {
      nonKeralaColleges.assignAll(allNonKeralaColleges);
    }
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

  Future<void> loadColleges() async {
  try {
    isLoading.value = true;
    final data = await _drawerApiServices.fetchColleges();

    // Store the master data
    allKeralaColleges = data['kerala'] ?? [];
    allNonKeralaColleges = data['nonKerala'] ?? [];

    // Set default lists
    keralaColleges.assignAll(allKeralaColleges);
    nonKeralaColleges.assignAll(allNonKeralaColleges);
  } catch (e) {
    print("Controller error: $e");
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
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
