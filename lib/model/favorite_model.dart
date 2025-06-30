class FavoritesModel {
  final bool status;
  final String userId;
  final Data? data;

  FavoritesModel({
    required this.status,
    required this.userId,
    this.data,
  });

  factory FavoritesModel.fromJson(Map<String, dynamic> json) => FavoritesModel(
        status: json["status"] ?? false,
        userId: json["user_id"].toString(),
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "user_id": userId,
        "data": data?.toJson(),
      };
}


class Data {
    Data({
        required this.favoriteNews,
        required this.favoriteEvents,
    });

    final List<FavoriteNew> favoriteNews;
    final List<FavoriteEvent> favoriteEvents;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            favoriteNews: json["favorite_news"] == null ? [] : List<FavoriteNew>.from(json["favorite_news"]!.map((x) => FavoriteNew.fromJson(x))),
            favoriteEvents: json["favorite_events"] == null ? [] : List<FavoriteEvent>.from(json["favorite_events"]!.map((x) => FavoriteEvent.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "favorite_news": favoriteNews.map((x) => x?.toJson()).toList(),
        "favorite_events": favoriteEvents.map((x) => x?.toJson()).toList(),
    };

}

class FavoriteEvent {
    FavoriteEvent({
        required this.favoriteId,
        required this.eventId,
        required this.eventTitle,
        required this.eventName,
        required this.eventShortDescription,
        required this.eventDescription,
        required this.eventstartDateDate,
        required this.eventEndDate,
        required this.totalSeats,
        required this.addedBy,
        required this.addedOn,
        required this.image,
        required this.document,
        required this.status,
        required this.feesPerSeat,
        required this.location,
        required this.descriptionLinks,
        required this.onlineBooking,
        required this.badges,
    });

    final String? favoriteId;
    final String? eventId;
    final String? eventTitle;
    final String? eventName;
    final String? eventShortDescription;
    final String? eventDescription;
    final DateTime? eventstartDateDate;
    final DateTime? eventEndDate;
    final String? totalSeats;
    final String? addedBy;
    final String? addedOn;
    final String? image;
    final String? document;
    final String? status;
    final List<DescriptionLink>? descriptionLinks;
    final String? feesPerSeat;
    final String? location;
    final String? onlineBooking;
    final String? badges;

    factory FavoriteEvent.fromJson(Map<String, dynamic> json){ 
        return FavoriteEvent(
            favoriteId: json["favorite_id"],
            eventId: json["event_id"],
            eventTitle: json["event_title"],
            eventName: json["event_name"],
            eventShortDescription: json["event_short_description"],
            eventDescription: json["event_description"],
            eventstartDateDate: DateTime.tryParse(json["eventstart_date_date"] ?? ""),
            eventEndDate: DateTime.tryParse(json["event_end_date"] ?? ""),
            totalSeats: json["total_seats"],
            addedBy: json["added_by"],
            addedOn: json["added_on"],
            image: json["image"],
            document: json["document"],
            status: json["status"],
            feesPerSeat: json["fees_per_seat"],
            location: json["location"],
            descriptionLinks: (json["description_links"] as List<dynamic>?)
          ?.map((e) => DescriptionLink.fromJson(e))
          .toList(),
            onlineBooking: json["online_booking"],
            badges: json["badges"],
        );
    }

    Map<String, dynamic> toJson() => {
        "favorite_id": favoriteId,
        "event_id": eventId,
        "event_title": eventTitle,
        "event_name": eventName,
        "event_short_description": eventShortDescription,
        "event_description": eventDescription,
        "eventstart_date_date": eventstartDateDate?.toIso8601String(),
        "event_end_date": eventEndDate?.toIso8601String(),
        "total_seats": totalSeats,
        "added_by": addedBy,
        "added_on": addedOn,
        "image": image,
        "document": document,
        "status": status,
        "fees_per_seat": feesPerSeat,
        "location": location,
        "description_links": descriptionLinks?.map((e) => e.toJson()).toList(),
        "online_booking": onlineBooking,
        "badges": badges,
    };

}

class FavoriteNew {
    FavoriteNew({
        required this.favoriteId,
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
        required this.descriptionLinks,
        required this.badges,
    });

    final String? favoriteId;
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
    final List<DescriptionLink>? descriptionLinks;
    final String? newsAuthor;
    final String? badges;

    factory FavoriteNew.fromJson(Map<String, dynamic> json){ 
        return FavoriteNew(
            favoriteId: json["favorite_id"],
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
            descriptionLinks: (json["description_links"] as List<dynamic>?)
          ?.map((e) => DescriptionLink.fromJson(e))
          .toList(),
            newsAuthor: json["news_author"],
            badges: json["badges"],
        );
    }

    Map<String, dynamic> toJson() => {
        "favorite_id": favoriteId,
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
        "description_links": descriptionLinks?.map((e) => e.toJson()).toList(),
        "news_category": newsCategory,
        "author": author,
        "news_author": newsAuthor,
        "badges": badges,
    };

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