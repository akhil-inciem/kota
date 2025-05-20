import 'package:get/get.dart';
import 'package:kota/apiServices/drawer_api_services.dart';
import 'package:kota/apiServices/events_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/event_model.dart';
import 'package:kota/model/executive_model.dart';
import 'package:kota/model/faq_model.dart';
import 'package:kota/model/vision_mission_model.dart';

class SideMenuController extends GetxController {
  final executiveList = <LeadersDetail>[].obs;
  final visionMission = <VisionDatum>[].obs;
  RxBool isLoading = false.obs;
  RxList<AbMemberFaq> faqList = <AbMemberFaq>[].obs;
  final DrawerApiServices _drawerApiServices = DrawerApiServices();
  RxInt expandedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await fetchExecutives();
    await fetchVisionAndMission();
  }

  Future<void> fetchExecutives() async {
    isLoading.value = true;
    try {
      final fetchedExecutives = await _drawerApiServices.fetchExecutives();
      executiveList.assignAll(fetchedExecutives);
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpansion(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  Future<void> loadFaqs() async {
    try {
      isLoading.value = true;
      final fetchedFaqs = await _drawerApiServices.fetchMemberFaqs();
      faqList.assignAll(fetchedFaqs);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVisionAndMission() async {
    isLoading.value = true;
    try {
      final fetchedVisionInfo = await _drawerApiServices.fetchVisionAndMission();
      visionMission.assignAll(fetchedVisionInfo);
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
