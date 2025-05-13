class TherapistDropDownModel {
    TherapistDropDownModel({
        required this.status,
        required this.messege,
        required this.data,
    });

    final bool? status;
    final String? messege;
    final TherapistDropdownData? data;

    factory TherapistDropDownModel.fromJson(Map<String, dynamic> json){ 
        return TherapistDropDownModel(
            status: json["status"],
            messege: json["messege"],
            data: json["data"] == null ? null : TherapistDropdownData.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "messege": messege,
        "data": data?.toJson(),
    };

}

class TherapistDropdownData {
    TherapistDropdownData({
        required this.districts,
        required this.gender,
        required this.highestQualification,
        required this.specialisation,
        required this.practiceArea,
    });

    final List<District> districts;
    final List<Gender> gender;
    final List<HighestQualification> highestQualification;
    final List<PracticeArea> specialisation;
    final List<PracticeArea> practiceArea;

    factory TherapistDropdownData.fromJson(Map<String, dynamic> json){ 
        return TherapistDropdownData(
            districts: json["districts"] == null ? [] : List<District>.from(json["districts"]!.map((x) => District.fromJson(x))),
            gender: json["gender"] == null ? [] : List<Gender>.from(json["gender"]!.map((x) => Gender.fromJson(x))),
            highestQualification: json["highest_qualification"] == null ? [] : List<HighestQualification>.from(json["highest_qualification"]!.map((x) => HighestQualification.fromJson(x))),
            specialisation: json["specialisation"] == null ? [] : List<PracticeArea>.from(json["specialisation"]!.map((x) => PracticeArea.fromJson(x))),
            practiceArea: json["practice_area"] == null ? [] : List<PracticeArea>.from(json["practice_area"]!.map((x) => PracticeArea.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "districts": districts.map((x) => x?.toJson()).toList(),
        "gender": gender.map((x) => x?.toJson()).toList(),
        "highest_qualification": highestQualification.map((x) => x?.toJson()).toList(),
        "specialisation": specialisation.map((x) => x?.toJson()).toList(),
        "practice_area": practiceArea.map((x) => x?.toJson()).toList(),
    };

}

class District {
    District({
        required this.districtId,
        required this.district,
        required this.status,
        required this.country,
        required this.state,
    });

    final String? districtId;
    final String? district;
    final String? status;
    final String? country;
    final String? state;

    factory District.fromJson(Map<String, dynamic> json){ 
        return District(
            districtId: json["district_id"],
            district: json["district"],
            status: json["status"],
            country: json["country"],
            state: json["state"],
        );
    }

    Map<String, dynamic> toJson() => {
        "district_id": districtId,
        "district": district,
        "status": status,
        "country": country,
        "state": state,
    };

}

class Gender {
    Gender({
        required this.genderId,
        required this.gender,
        required this.status,
    });

    final String? genderId;
    final String? gender;
    final String? status;

    factory Gender.fromJson(Map<String, dynamic> json){ 
        return Gender(
            genderId: json["gender_id"],
            gender: json["gender"],
            status: json["status"],
        );
    }

    Map<String, dynamic> toJson() => {
        "gender_id": genderId,
        "gender": gender,
        "status": status,
    };

}

class HighestQualification {
    HighestQualification({
        required this.hqId,
        required this.highestQualification,
        required this.status,
        required this.addedOn,
        required this.addedBy,
    });

    final String? hqId;
    final String? highestQualification;
    final String? status;
    final DateTime? addedOn;
    final String? addedBy;

    factory HighestQualification.fromJson(Map<String, dynamic> json){ 
        return HighestQualification(
            hqId: json["hq_id"],
            highestQualification: json["highest_qualification"],
            status: json["status"],
            addedOn: DateTime.tryParse(json["added_on"] ?? ""),
            addedBy: json["added_by"],
        );
    }

    Map<String, dynamic> toJson() => {
        "hq_id": hqId,
        "highest_qualification": highestQualification,
        "status": status,
        "added_on": addedOn?.toIso8601String(),
        "added_by": addedBy,
    };

}

class PracticeArea {
    PracticeArea({
        required this.spId,
        required this.specialization,
    });

    final String? spId;
    final String? specialization;

    factory PracticeArea.fromJson(Map<String, dynamic> json){ 
        return PracticeArea(
            spId: json["sp_id"],
            specialization: json["specialization"],
        );
    }

    Map<String, dynamic> toJson() => {
        "sp_id": spId,
        "specialization": specialization,
    };

}
