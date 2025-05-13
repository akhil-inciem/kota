import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:kota/constants/api.dart';
import 'package:kota/model/clinic_model.dart';
import 'package:kota/model/therapist_dropdwon_model.dart';
import 'package:kota/model/therapist_model.dart';

class FindApiServices {
  final Dio _dio = Dio();

  Future<TherapistDropDownModel> fetchTherapistDropdownDetails() async {
    try {
      final response = await _dio.get(ApiEndpoints.therapistDropdownData); 

      if (response.statusCode == 200 ) {
        final decoded = jsonDecode(response.data);
      final therapistDropdownData = TherapistDropDownModel.fromJson(decoded);
      return therapistDropdownData; 
    } else {
      throw Exception("Failed to load news");
    }
    } catch (e) {
      print(e);
      throw Exception("Failed to load user profile: $e");
    }
  }

  Future<List<TherapistDatum>> fetchSearchResults({
  required String districtId,
  required String genderId,
  required String practiceAreaId,
}) async {
  try {
    final formData = FormData.fromMap({
      "district": districtId,
      "gender": genderId,
      "practice_area": practiceAreaId,
    });

    final response = await _dio.post(
      ApiEndpoints.findTherapist,
      data: formData,
    );

    if (response.statusCode == 200) {
      final therapistModel = TherapistModel.fromJson(response.data);
      return therapistModel.data;
    } else {
      throw Exception("Failed to fetch search results");
    }
  } catch (e) {
    print("Error fetching search results: $e");
    throw Exception("Search failed: $e");
  }
}

Future<List<Clinic>> fetchClinicResults(bool isGov) async {
    try {
      final endpoint = isGov
        ? ApiEndpoints.findGovClinic 
        : ApiEndpoints.findPrivateClinic; 

    final response = await _dio.get(endpoint);

      if (response.statusCode == 200 ) {
        final decoded = jsonDecode(response.data);
      final clinicsData = ClinicsModel.fromJson(decoded);
      return clinicsData.data!.clinics; 
    } else {
      throw Exception("Failed to load news");
    }
    } catch (e) {
      print(e);
      throw Exception("Failed to load user profile: $e");
    }
  }
}