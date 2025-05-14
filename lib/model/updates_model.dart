class UpdatesModel {
    UpdatesModel({
        required this.status,
        required this.messege,
        required this.data,
    });

    final bool? status;
    final String? messege;
    final Data? data;

    factory UpdatesModel.fromJson(Map<String, dynamic> json){ 
        return UpdatesModel(
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
    required this.news,
    required this.events,
  });

  final List<Map<String, String>> news;
  final List<dynamic> events;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      news: json["news"] == null
          ? []
          : List<Map<String, String>>.from(
              (json["news"] as List)
                  .where((x) => x != null && x is Map) // filter nulls
                  .map((x) => Map.from(x).map(
                        (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
                      )),
            ),
      events: json["events"] == null
          ? []
          : List<dynamic>.from(
              (json["events"] as List).where((x) => x != null),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "news": news.map((x) => Map.from(x)).toList(),
        "events": events,
      };
}

