class PollModel {
    PollModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final List<PollData> data;

    factory PollModel.fromJson(Map<String, dynamic> json){ 
        return PollModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<PollData>.from(json["data"]!.map((x) => PollData.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
    };

}

class PollData {
    PollData({
        required this.id,
        required this.userName,
        required this.title,
        required this.discription,
        required this.createdBy,
        required this.pollFeild,
        required this.expairydate,
        required this.allowmultiple,
        required this.createdAt,
        required this.updateAt,
        required this.editable,
        required this.reactionCounts,
        required this.expired,
        required this.userVote,
        required this.creatorName,
    });

    final String? id;
    final String? title;
    final String? userName;
    final String? discription;
    final String? createdBy;
    final String? pollFeild;
    final String? userVote;
    final DateTime? expairydate;
    final String? allowmultiple;
    final DateTime? createdAt;
    final String? updateAt;
    final bool? editable;
    final Map<String, num> reactionCounts;
    final bool? expired;
    final String? creatorName;

    factory PollData.fromJson(Map<String, dynamic> json){ 
        return PollData(
            id: json["id"],
            title: json["title"],
            userName: json['user_name'],
            discription: json["discription"],
            createdBy: json["created_by"],
            pollFeild: json["poll_feild"],
            userVote: json['user_vote'],
            expairydate: DateTime.tryParse(json["expairydate"] ?? ""),
            allowmultiple: json["allowmultiple"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updateAt: json["update_at"],
            editable: json["editable"],
            reactionCounts: Map.from(json["reaction_counts"]).map((k, v) => MapEntry<String, num>(k, v)),
            expired: json["expired"],
            creatorName: json['creator_name']
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        'user_name': userName,
        "discription": discription,
        "created_by": createdBy,
        "poll_feild": pollFeild,
        'user_vote': userVote,
        "expairydate": "${expairydate!.year.toString().padLeft(4,'0')}-${expairydate!.month.toString().padLeft(2,'0')}-${expairydate!.day.toString().padLeft(2,'0')}",
        "allowmultiple": allowmultiple,
        "created_at": createdAt?.toIso8601String(),
        "update_at": updateAt,
        "editable": editable,
        "reaction_counts": Map.from(reactionCounts).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "expired": expired,
        'creator_name': creatorName
    };

}

    extension PollDataCopy on PollData {
  PollData copyWith({
    String? id,
    String? title,
    String? userName,
    String? discription,
    String? createdBy,
    String? pollFeild,
    String? userVote,
    DateTime? expairydate,
    String? allowmultiple,
    DateTime? createdAt,
    String? updateAt,
    bool? editable,
    Map<String, num>? reactionCounts,
    bool? expired,
    String? creatorName,
  }) {
    return PollData(
      id: id ?? this.id,
      title: title ?? this.title,
      userName: userName ?? this.userName,
      discription: discription ?? this.discription,
      createdBy: createdBy ?? this.createdBy,
      pollFeild: pollFeild ?? this.pollFeild,
      userVote: userVote ?? this.userVote,
      expairydate: expairydate ?? this.expairydate,
      allowmultiple: allowmultiple ?? this.allowmultiple,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      editable: editable ?? this.editable,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      expired: expired ?? this.expired,
      creatorName: creatorName ?? this.creatorName
    );
  }
}

