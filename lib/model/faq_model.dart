class FaqModel {
    FaqModel({
        required this.status,
        required this.messege,
        required this.data,
    });

    final bool? status;
    final String? messege;
    final Data? data;

    factory FaqModel.fromJson(Map<String, dynamic> json){ 
        return FaqModel(
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
        required this.abMemberFaq,
    });

    final List<AbMemberFaq> abMemberFaq;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            abMemberFaq: json["ab_member_faq"] == null ? [] : List<AbMemberFaq>.from(json["ab_member_faq"]!.map((x) => AbMemberFaq.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "ab_member_faq": abMemberFaq.map((x) => x?.toJson()).toList(),
    };

}

class AbMemberFaq {
    AbMemberFaq({
        required this.mfId,
        required this.question,
        required this.answer,
        required this.sortOrder,
        required this.status,
        required this.addedOn,
        required this.addedBy,
    });

    final String? mfId;
    final String? question;
    final String? answer;
    final String? sortOrder;
    final String? status;
    final String? addedOn;
    final String? addedBy;

    factory AbMemberFaq.fromJson(Map<String, dynamic> json){ 
        return AbMemberFaq(
            mfId: json["mf_id"],
            question: json["question"],
            answer: json["answer"],
            sortOrder: json["sort_order"],
            status: json["status"],
            addedOn: json["added_on"],
            addedBy: json["added_by"],
        );
    }

    Map<String, dynamic> toJson() => {
        "mf_id": mfId,
        "question": question,
        "answer": answer,
        "sort_order": sortOrder,
        "status": status,
        "added_on": addedOn,
        "added_by": addedBy,
    };

}
