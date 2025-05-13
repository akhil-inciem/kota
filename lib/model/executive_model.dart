

class ExecutiveModel {
    ExecutiveModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final ExecutiveData? data;

    factory ExecutiveModel.fromJson(Map<String, dynamic> json){ 
        return ExecutiveModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? null : ExecutiveData.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };

}

class ExecutiveData {
    ExecutiveData({
        required this.leadersDetails,
    });

    final List<LeadersDetail> leadersDetails;

    factory ExecutiveData.fromJson(Map<String, dynamic> json){ 
        return ExecutiveData(
            leadersDetails: json["leaders_details"] == null ? [] : List<LeadersDetail>.from(json["leaders_details"]!.map((x) => LeadersDetail.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "leaders_details": leadersDetails.map((x) => x?.toJson()).toList(),
    };

}

class LeadersDetail {
  LeadersDetail({
    required this.designation,
    required this.officialEmail,
    required this.officialMobile,
    required this.portalImage,
    required this.firstName,
    required this.lastName,
  });

  final String? designation;
  final String? officialEmail;
  final String? officialMobile;
  final String? portalImage;
  final String? firstName;
  final String? lastName;

  factory LeadersDetail.fromJson(Map<String, dynamic> json) {
    return LeadersDetail(
      designation: json["designation"],
      officialEmail: json["official_email"],
      officialMobile: json["official_mobile"],
      portalImage: json["portal_image"],
      firstName: json["first_name"],
      lastName: json["last_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "designation": designation,
        "official_email": officialEmail,
        "official_mobile": officialMobile,
        "portal_image": portalImage,
        "first_name": firstName,
        "last_name": lastName,
      };

  @override
  String toString() {
    return 'LeadersDetail(designation: $designation, name: $firstName $lastName, email: $officialEmail, phone: $officialMobile)';
  }
}

