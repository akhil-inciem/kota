class FavoritesModel {
  bool? status;
  String? message;
  Data? data;

  FavoritesModel({this.status, this.message, this.data});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<News>? news;
  List<Events>? events;

  Data({this.news, this.events});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(new News.fromJson(v));
      });
    }
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class News {
  String? newsId;
  String? newsTitle;
  String? newsSubTitle;
  String? newsDescription;
  String? newsImage;
  String? newsDate;
  String? attachment;
  String? addedOn;
  String? addedBy;
  String? status;
  String? newsCategory;
  Null? author;
  String? newsAuthor;
  String? badges;
  String? faverites;

  News(
      {this.newsId,
      this.newsTitle,
      this.newsSubTitle,
      this.newsDescription,
      this.newsImage,
      this.newsDate,
      this.attachment,
      this.addedOn,
      this.addedBy,
      this.status,
      this.newsCategory,
      this.author,
      this.newsAuthor,
      this.badges,
      this.faverites});

  News.fromJson(Map<String, dynamic> json) {
    newsId = json['news_id'];
    newsTitle = json['news_title'];
    newsSubTitle = json['news_sub_title'];
    newsDescription = json['news_description'];
    newsImage = json['news_image'];
    newsDate = json['news_date'];
    attachment = json['attachment'];
    addedOn = json['added_on'];
    addedBy = json['added_by'];
    status = json['status'];
    newsCategory = json['news_category'];
    author = json['author'];
    newsAuthor = json['news_author'];
    badges = json['badges'];
    faverites = json['faverites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news_id'] = this.newsId;
    data['news_title'] = this.newsTitle;
    data['news_sub_title'] = this.newsSubTitle;
    data['news_description'] = this.newsDescription;
    data['news_image'] = this.newsImage;
    data['news_date'] = this.newsDate;
    data['attachment'] = this.attachment;
    data['added_on'] = this.addedOn;
    data['added_by'] = this.addedBy;
    data['status'] = this.status;
    data['news_category'] = this.newsCategory;
    data['author'] = this.author;
    data['news_author'] = this.newsAuthor;
    data['badges'] = this.badges;
    data['faverites'] = this.faverites;
    return data;
  }
}

class Events {
  String? eventId;
  String? eventTitle;
  String? eventName;
  String? eventShortDescription;
  String? eventDescription;
  String? eventstartDateDate;
  String? eventEndDate;
  String? totalSeats;
  String? addedBy;
  String? addedOn;
  String? image;
  String? document;
  String? status;
  String? feesPerSeat;
  String? location;
  String? onlineBooking;
  String? badges;
  String? faverites;

  Events(
      {this.eventId,
      this.eventTitle,
      this.eventName,
      this.eventShortDescription,
      this.eventDescription,
      this.eventstartDateDate,
      this.eventEndDate,
      this.totalSeats,
      this.addedBy,
      this.addedOn,
      this.image,
      this.document,
      this.status,
      this.feesPerSeat,
      this.location,
      this.onlineBooking,
      this.badges,
      this.faverites});

  Events.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventTitle = json['event_title'];
    eventName = json['event_name'];
    eventShortDescription = json['event_short_description'];
    eventDescription = json['event_description'];
    eventstartDateDate = json['eventstart_date_date'];
    eventEndDate = json['event_end_date'];
    totalSeats = json['total_seats'];
    addedBy = json['added_by'];
    addedOn = json['added_on'];
    image = json['image'];
    document = json['document'];
    status = json['status'];
    feesPerSeat = json['fees_per_seat'];
    location = json['location'];
    onlineBooking = json['online_booking'];
    badges = json['badges'];
    faverites = json['faverites'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_title'] = this.eventTitle;
    data['event_name'] = this.eventName;
    data['event_short_description'] = this.eventShortDescription;
    data['event_description'] = this.eventDescription;
    data['eventstart_date_date'] = this.eventstartDateDate;
    data['event_end_date'] = this.eventEndDate;
    data['total_seats'] = this.totalSeats;
    data['added_by'] = this.addedBy;
    data['added_on'] = this.addedOn;
    data['image'] = this.image;
    data['document'] = this.document;
    data['status'] = this.status;
    data['fees_per_seat'] = this.feesPerSeat;
    data['location'] = this.location;
    data['online_booking'] = this.onlineBooking;
    data['badges'] = this.badges;
    data['faverites'] = this.faverites;
    return data;
  }
}
