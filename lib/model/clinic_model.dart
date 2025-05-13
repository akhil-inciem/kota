class ClinicsModel {
    ClinicsModel({
        required this.status,
        required this.messege,
        required this.data,
    });

    final bool? status;
    final String? messege;
    final ClinicData? data;

    factory ClinicsModel.fromJson(Map<String, dynamic> json){ 
        return ClinicsModel(
            status: json["status"],
            messege: json["messege"],
            data: json["data"] == null ? null : ClinicData.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "messege": messege,
        "data": data?.toJson(),
    };

}

class ClinicData {
    ClinicData({
        required this.clinics,
    });

    final List<Clinic> clinics;

    factory ClinicData.fromJson(Map<String, dynamic> json){ 
        return ClinicData(
            clinics: json["clinics"] == null ? [] : List<Clinic>.from(json["clinics"]!.map((x) => Clinic.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "clinics": clinics.map((x) => x?.toJson()).toList(),
    };

}

class Clinic {
    Clinic({
        required this.institutionId,
        required this.nameAndPlaceOfInstitution,
        required this.institutionType,
        required this.country,
        required this.state,
        required this.district,
        required this.address,
        required this.pincode,
        required this.phoneNumber,
        required this.secondaryNumber,
        required this.managedBy,
        required this.startedOn,
        required this.description,
        required this.status,
        required this.publicDisplay,
        required this.districtId,
    });

    final String? institutionId;
    final String? nameAndPlaceOfInstitution;
    final String? institutionType;
    final String? country;
    final String? state;
    final String? district;
    final String? address;
    final String? pincode;
    final String? phoneNumber;
    final String? secondaryNumber;
    final String? managedBy;
    final String? startedOn;
    final String? description;
    final String? status;
    final String? publicDisplay;
    final String? districtId;

    factory Clinic.fromJson(Map<String, dynamic> json){ 
        return Clinic(
            institutionId: json["institution_id"],
            nameAndPlaceOfInstitution: json["name_and_place_of_institution"],
            institutionType: json["institution_type"],
            country: json["country"],
            state: json["state"],
            district: json["district"],
            address: json["address"],
            pincode: json["pincode"],
            phoneNumber: json["phone_number"],
            secondaryNumber: json["secondary_number"],
            managedBy: json["managed_by"],
            startedOn: json["started_on"],
            description: json["description"],
            status: json["status"],
            publicDisplay: json["public_display"],
            districtId: json["district_id"],
        );
    }

    Map<String, dynamic> toJson() => {
        "institution_id": institutionId,
        "name_and_place_of_institution": nameAndPlaceOfInstitution,
        "institution_type": institutionType,
        "country": country,
        "state": state,
        "district": district,
        "address": address,
        "pincode": pincode,
        "phone_number": phoneNumber,
        "secondary_number": secondaryNumber,
        "managed_by": managedBy,
        "started_on": startedOn,
        "description": description,
        "status": status,
        "public_display": publicDisplay,
        "district_id": districtId,
    };

}
