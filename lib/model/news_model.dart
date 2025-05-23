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
    final dynamic badges;
    final dynamic favorites;

    factory NewsDatum.fromJson(Map<String, dynamic> json){ 
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
            favorites: json["favorites"],
        );
    }

    Map<String, dynamic> toJson() => {
        "news_id": newsId,
        "news_title": newsTitle,
        "news_sub_title": newsSubTitle,
        "news_description": newsDescription,
        "news_image": newsImage,
        "news_date": "${newsDate!.year.toString().padLeft(4,'0')}-${newsDate!.month.toString().padLeft(2,'0')}-${newsDate!.day.toString().padLeft(2,'0')}",
        "attachment": attachment,
        "added_on": addedOn,
        "added_by": addedBy,
        "status": status,
        "news_category": newsCategory,
        "author": author,
        "news_author": newsAuthor,
        "badges": badges,
        "favorites": favorites,
    };

}
