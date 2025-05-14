class MemberShipModel {
  MemberShipModel({
    required this.status,
    required this.messege,
    required this.data,
  });

  final bool? status;
  final String? messege;
  final Data? data;

  factory MemberShipModel.fromJson(Map<String, dynamic> json) {
    return MemberShipModel(
      status: json["status"],
      messege: json["messege"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "messege": messege,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.member,
    required this.membershipExpiryDate,
    required this.status,
    required this.daysRemaining,
    required this.daysExpired,
  });

  final String? member;
  final DateTime? membershipExpiryDate;
  final String? status;
  final num? daysRemaining;
  final num? daysExpired;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      member: json["member"],
      membershipExpiryDate: DateTime.tryParse(
        json["membership_expiry_date"] ?? "",
      ),
      status: json["status"],
      daysRemaining: json["days_remaining"],
      daysExpired: json["days_expired"],
    );
  }

  Map<String, dynamic> toJson() => {
    "member": member,
    "membership_expiry_date":
        "${membershipExpiryDate!.year.toString().padLeft(4, '0')}-${membershipExpiryDate!.month.toString().padLeft(2, '0')}-${membershipExpiryDate!.day.toString().padLeft(2, '0')}",
    "status": status,
    "days_remaining": daysRemaining,
    "days_expired": daysExpired,
  };
}
