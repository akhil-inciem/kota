class UpdatesModel {
  UpdatesModel({
    required this.status,
    required this.messege,
    required this.data,
  });

  final bool? status;
  final String? messege;
  final Data? data;

  factory UpdatesModel.fromJson(Map<String, dynamic> json) {
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
    required this.threads,
    required this.likedMembers,
    required this.commentedMembers,
    required this.repliedMembers,
    required this.likedComments,
    required this.pollCreated,
  });

  final List<Map<String, String>> news;
  final List<dynamic> events;
  final List<dynamic> threads;
  final List<Map<String, String>> likedMembers;
  final List<Map<String, String>> commentedMembers;
  final List<Map<String, String>> repliedMembers;
  final List<Map<String, String>> likedComments;
  final List<Map<String, String>> pollCreated;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      news: _parseMapList(json["news"]),
      events: json["events"] == null ? [] : List<dynamic>.from(json["events"]),
      threads: json["threads"] == null ? [] : List<dynamic>.from(json["threads"]),
      likedMembers: _parseMapList(json["liked_members"]),
      commentedMembers: _parseMapList(json["commented_members"]),
      repliedMembers: _parseMapList(json["replied_members"]),
      likedComments: _parseMapList(json["liked_comments"]),
      pollCreated: _parseMapList(json["poll_created"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "news": news,
        "events": events,
        "threads": threads,
        "liked_members": likedMembers,
        "commented_members": commentedMembers,
        "replied_members": repliedMembers,
        "liked_comments": likedComments,
        "poll_created": pollCreated,
      };

  static List<Map<String, String>> _parseMapList(dynamic jsonList) {
    if (jsonList == null) return [];
    return List<Map<String, String>>.from(
      (jsonList as List).where((x) => x != null).map(
            (x) => Map.from(x).map(
              (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
            ),
          ),
    );
  }
}
