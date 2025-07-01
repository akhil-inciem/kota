class NewsModel {
    NewsModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final List<NewsDatum> data;

    factory NewsModel.fromJson(Map<String, dynamic> json){ 
        return NewsModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<NewsDatum>.from(json["data"]!.map((x) => NewsDatum.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
    };

}

class NewsDatum {
  NewsDatum({
    required this.newsId,
    required this.newsTitle,
    required this.newsSubTitle,
    required this.newsDescription,
    required this.newsImage,
    required this.newsDate,
    required this.attachment,
    required this.addedOn,
    required this.addedBy,
    required this.status,
    required this.newsCategory,
    required this.author,
    required this.newsAuthor,
    required this.badges,
    required this.adminImage,
    required this.adminRoleId,
    required this.adminRoleTitle,
    required this.addedAdminName,
    required this.descriptionLinks,
    required this.favorites,
  });

  final String? newsId;
  final String? newsTitle;
  final String? newsSubTitle;
  final String? newsDescription;
  final String? newsImage;
  final DateTime? newsDate;
  final String? attachment;
  final String? addedOn;
  final String? addedBy;
  final String? status;
  final String? newsCategory;
  final dynamic author;
  final String? newsAuthor;
  final String? badges;
  final String? adminImage;
  final String? adminRoleId;
  final String? adminRoleTitle;
  final String? addedAdminName;
  final List<DescriptionLink>? descriptionLinks;
  final int? favorites;

  factory NewsDatum.fromJson(Map<String, dynamic> json) {
    return NewsDatum(
      newsId: json["news_id"],
      newsTitle: json["news_title"],
      newsSubTitle: json["news_sub_title"],
      newsDescription: json["news_description"],
      newsImage: json["news_image"],
      newsDate: DateTime.tryParse(json["news_date"] ?? ""),
      attachment: json["attachment"],
      addedOn: json["added_on"],
      addedBy: json["added_by"],
      status: json["status"],
      newsCategory: json["news_category"],
      author: json["author"],
      newsAuthor: json["news_author"],
      badges: json["badges"],
      adminImage: json["admin_image"],
      adminRoleId: json["admin_role_id"],
      adminRoleTitle: json["admin_role_title"],
      addedAdminName: json["added_admin_name"],
      descriptionLinks: (json["description_links"] as List<dynamic>?)
          ?.map((e) => DescriptionLink.fromJson(e))
          .toList(),
      favorites: int.tryParse(json["favorites"].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        "news_id": newsId,
        "news_title": newsTitle,
        "news_sub_title": newsSubTitle,
        "news_description": newsDescription,
        "news_image": newsImage,
        "news_date": newsDate != null
            ? "${newsDate!.year.toString().padLeft(4, '0')}-${newsDate!.month.toString().padLeft(2, '0')}-${newsDate!.day.toString().padLeft(2, '0')}"
            : null,
        "attachment": attachment,
        "added_on": addedOn,
        "added_by": addedBy,
        "status": status,
        "news_category": newsCategory,
        "author": author,
        "news_author": newsAuthor,
        "badges": badges,
        "admin_image": adminImage,
        "admin_role_id": adminRoleId,
        "admin_role_title": adminRoleTitle,
        "added_admin_name": addedAdminName,
        "description_links": descriptionLinks?.map((e) => e.toJson()).toList(),
        "favorites": favorites,
      };

      NewsDatum copyWith({
  String? newsId,
  String? newsTitle,
  String? newsSubTitle,
  String? newsDescription,
  String? newsImage,
  DateTime? newsDate,
  String? attachment,
  String? addedOn,
  String? addedBy,
  String? status,
  String? newsCategory,
  dynamic author,
  String? newsAuthor,
  String? badges,
  String? adminImage,
  String? adminRoleId,
  String? adminRoleTitle,
  String? addedAdminName,
  List<DescriptionLink>? descriptionLinks,
  int? favorites,
}) {
  return NewsDatum(
    newsId: newsId ?? this.newsId,
    newsTitle: newsTitle ?? this.newsTitle,
    newsSubTitle: newsSubTitle ?? this.newsSubTitle,
    newsDescription: newsDescription ?? this.newsDescription,
    newsImage: newsImage ?? this.newsImage,
    newsDate: newsDate ?? this.newsDate,
    attachment: attachment ?? this.attachment,
    addedOn: addedOn ?? this.addedOn,
    addedBy: addedBy ?? this.addedBy,
    status: status ?? this.status,
    newsCategory: newsCategory ?? this.newsCategory,
    author: author ?? this.author,
    newsAuthor: newsAuthor ?? this.newsAuthor,
    badges: badges ?? this.badges,
    adminImage: adminImage ?? this.adminImage,
    adminRoleId: adminRoleId ?? this.adminRoleId,
    adminRoleTitle: adminRoleTitle ?? this.adminRoleTitle,
    addedAdminName: addedAdminName ?? this.addedAdminName,
    descriptionLinks: descriptionLinks ?? this.descriptionLinks,
    favorites: favorites ?? this.favorites,
  );
}

}

class DescriptionLink {
  DescriptionLink({
    required this.placeholder,
    required this.url,
    required this.label,
  });

  final String? placeholder;
  final String? url;
  final String? label;

  factory DescriptionLink.fromJson(Map<String, dynamic> json) {
    return DescriptionLink(
      placeholder: json["placeholder"],
      url: json["url"],
      label: json["label"],
    );
  }

  Map<String, dynamic> toJson() => {
        "placeholder": placeholder,
        "url": url,
        "label": label,
      };
}

