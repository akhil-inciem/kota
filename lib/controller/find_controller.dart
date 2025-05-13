import 'package:get/get.dart';
import 'package:kota/apiServices/find_api_services.dart';
import 'package:kota/data/dummy.dart';
import 'package:kota/model/clinic_model.dart';
import 'package:kota/model/therapist_dropdwon_model.dart';
import 'package:kota/model/therapist_model.dart';

class FindController extends GetxController {
  var isTherapistLoading = false.obs;
  var isTherapistSearched = false.obs;

  final fetchedTherapistList = <TherapistDatum>[].obs;
final filteredTherapistList = <TherapistDatum>[].obs;

final fetchedClinicList = <Clinic>[].obs;
final filteredClinicList = <Clinic>[].obs;

  final isClinicSearched = false.obs;
  final RxBool isClinicLoading = false.obs;
  final isGovClinic = false.obs;
  final isPrivateClinic = false.obs;

  final districts = <District>[].obs;
  final genders = <Gender>[].obs;
  final practiceAreas = <PracticeArea>[].obs;

  final selectedDistrict = Rxn<District>();
  final selectedGender = Rxn<Gender>();
  final selectedPracticeArea = Rxn<PracticeArea>();

  var clinicResults = <Map<String, dynamic>>[].obs;

  final FindApiServices _findApiServices = FindApiServices();

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      final dropdownData =
          await _findApiServices.fetchTherapistDropdownDetails();
      final districtList = dropdownData.data?.districts ?? [];
      final genderList = dropdownData.data?.gender ?? [];
      final practiceAreaList = dropdownData.data?.practiceArea ?? [];
      districts.value = [
        District(
          districtId: '',
          district: '-- Select District --',
          status: '',
          country: '',
          state: '',
        ),
        ...districtList,
      ];
      genders.value = [
        Gender(genderId: '', gender: '-- Select Gender --', status: ''),
        ...genderList,
      ];
      practiceAreas.value = [
        PracticeArea(spId: '', specialization: '-- Select Practice Area --'),
        ...practiceAreaList,
      ];
    } catch (e) {
      print("Error fetching dropdown data: $e");
    }
  }

  void resetTherapistSearch() {
    isTherapistSearched.value = false;
  }

  Future<void> findTherapist() async {
  try {
    isTherapistLoading.value = true;
    final results = await _findApiServices.fetchSearchResults(
      districtId: selectedDistrict.value?.districtId ?? "",
      genderId: selectedGender.value?.genderId ?? "",
      practiceAreaId: selectedPracticeArea.value?.spId ?? "",
    );
    fetchedTherapistList.value = results;
    filteredTherapistList.value = results;
    isTherapistLoading.value = false;
    isTherapistSearched.value = true;
  } catch (e) {
    print("Therapist fetch failed: $e");
  }
}

void searchClinic({required bool isGov}) async {
  isGovClinic.value = isGov;
  isPrivateClinic.value = !isGov;
  isClinicLoading.value = true;

  final results = await _findApiServices.fetchClinicResults(isGov);
  fetchedClinicList.value = results;
  filteredClinicList.value = results;

  isClinicSearched.value = true;
  isClinicLoading.value = false;
}

void filterTherapists(String query) {
  if (query.isEmpty) {
    filteredTherapistList.value = fetchedTherapistList;
  } else {
    filteredTherapistList.value = fetchedTherapistList
        .where((item) =>
            (item.firstName ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (item.district ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

void filterClinics(String query) {
  if (query.isEmpty) {
    filteredClinicList.value = fetchedClinicList;
  } else {
    filteredClinicList.value = fetchedClinicList
        .where((item) =>
            (item.nameAndPlaceOfInstitution ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (item.district ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

  void resetClinicSearch() {
    isClinicSearched.value = false;
    isGovClinic.value = false;
    isPrivateClinic.value = false;
    fetchedClinicList.clear();
  }
}
