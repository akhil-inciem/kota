class TherapistModel {
    TherapistModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final List<TherapistDatum> data;

    factory TherapistModel.fromJson(Map<String, dynamic> json){ 
        return TherapistModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<TherapistDatum>.from(json["data"]!.map((x) => TherapistDatum.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
    };

}

class TherapistDatum {
    TherapistDatum({
        required this.firstName,
        required this.lastName,
        required this.district,
    });

    final String? firstName;
    final String? lastName;
    final String? district;

    factory TherapistDatum.fromJson(Map<String, dynamic> json){ 
        return TherapistDatum(
            firstName: json["first_name"],
            lastName: json["last_name"],
            district: json["district"],
        );
    }

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "district": district,
    };

}
