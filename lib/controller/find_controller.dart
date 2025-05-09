import 'package:get/get.dart';
import 'package:kota/data/dummy.dart';

class FindController extends GetxController {
  var isTherapistLoading = false.obs;
var isClinicLoading = false.obs;
  var isTherapistSearched = false.obs;
var isClinicSearched = false.obs;

  final districts = <String>[].obs;
  final genders = <String>[].obs;
  final practiceAreas = <String>[].obs;

  final selectedDistrict = RxnString();
  final selectedGender = RxnString();
  final selectedPracticeArea = RxnString();

  var therapistResults = <Map<String, dynamic>>[].obs;
var clinicResults = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
  }

  void fetchDropdownData() async {
    await Future.delayed(Duration(milliseconds: 200));

    // Simulate data from API
    districts.value = ['District A', 'District B', 'District C'];
    genders.value = ['Male', 'Female', 'Other'];
    practiceAreas.value = ['Pediatrics', 'Geriatrics', 'Rehab'];
  }

  void performSearch({required bool isClinic}) async {
  if (isClinic) {
    isClinicLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    clinicResults.assignAll(DummyData.dummyClinicResults);
    isClinicLoading.value = false;
    isClinicSearched.value = true;
  } else {
    isTherapistLoading.value = true;
    await Future.delayed(Duration(seconds: 1));
    therapistResults.assignAll(DummyData.dummyTherapistResults);
    isTherapistLoading.value = false;
    isTherapistSearched.value = true;
  }
}


void resetSearch({required bool isClinic}) {
  if (isClinic) {
    isClinicSearched.value = false;
    clinicResults.clear();
  } else {
    isTherapistSearched.value = false;
    therapistResults.clear();
  }
}


}
