class CollegesModel {
  bool status;
  String messege;
  CollegeData data;

  CollegesModel({
    required this.status,
    required this.messege,
    required this.data,
  });

  factory CollegesModel.fromJson(Map<String, dynamic> json) {
    return CollegesModel(
      status: json['status'] ?? false,
      messege: json['messege'] ?? '',
      data: CollegeData.fromJson(json['data'] ?? {}),
    );
  }
}


class CollegeData {
  List<OtCollegesKerala> otCollegesKerala;
  List<OtCollegesKerala> otCollegesNonKerala;

  CollegeData({
    required this.otCollegesKerala,
    required this.otCollegesNonKerala,
  });

  factory CollegeData.fromJson(Map<String, dynamic> json) {
    return CollegeData(
      otCollegesKerala: (json['ot_colleges_kerala'] as List<dynamic>? ?? [])
          .map((e) => OtCollegesKerala.fromJson(e))
          .toList(),
      otCollegesNonKerala: (json['ot_colleges_non_kerala'] as List<dynamic>? ?? [])
          .map((e) => OtCollegesKerala.fromJson(e))
          .toList(),
    );
  }
}


class OtCollegesKerala {
  String id;
  String collegeName;
  String university;
  String principal;
  String ugCourses;
  String pgCourses;
  String address;
  String city;
  String state;
  String status;
  String addedOn;
  String accredited;
  String addedBy;

  OtCollegesKerala({
    required this.id,
    required this.collegeName,
    required this.university,
    required this.principal,
    required this.ugCourses,
    required this.pgCourses,
    required this.address,
    required this.city,
    required this.state,
    required this.status,
    required this.addedOn,
    required this.accredited,
    required this.addedBy,
  });

  factory OtCollegesKerala.fromJson(Map<String, dynamic> json) {
    return OtCollegesKerala(
      id: json['id'] ?? '',
      collegeName: json['college_name'] ?? '',
      university: json['university'] ?? '',
      principal: json['principal'] ?? '',
      ugCourses: json['ug_courses'] ?? '',
      pgCourses: json['pg_courses'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      status: json['status'] ?? '',
      addedOn: json['added_on'] ?? '',
      accredited: json['accredited'] ?? '',
      addedBy: json['added_by'] ?? '',
    );
  }
}

