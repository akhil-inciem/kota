class ForumModel {
  bool? status;
  String? message;
  List<ForumData>? data;

  ForumModel({this.status, this.message, this.data});

  ForumModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ForumData>[];
      json['data'].forEach((v) {
        data!.add(new ForumData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ForumData {
  String? id;
  String? title;
  String? content;
  String? createdAt;
  String? firstName;
  String? photo;
  String? lastName;
  String? likeCount;
  String? commentCount;
  String? contentSnippet;
  List<String>? images;
  List<RecentLikes>? recentLikes;

  ForumData({
    this.id,
      this.title,
      this.content,
      this.createdAt,
      this.firstName,
      this.photo,
      this.lastName,
      this.likeCount,
      this.commentCount,
      this.contentSnippet,
      this.images,
      this.recentLikes});

  ForumData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    photo = json['photo'];
    lastName = json['last_name'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    contentSnippet = json['content_snippet'];
    images = json['images'].cast<String>();
    if (json['recent_likes'] != null) {
      recentLikes = <RecentLikes>[];
      json['recent_likes'].forEach((v) {
        recentLikes!.add(new RecentLikes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['first_name'] = this.firstName;
    data['photo'] = this.photo;
    data['last_name'] = this.lastName;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['content_snippet'] = this.contentSnippet;
    data['images'] = this.images;
    if (this.recentLikes != null) {
      data['recent_likes'] = this.recentLikes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentLikes {
  String? id;
  String? firstName;
  String? lastName;
  String? photo;

  RecentLikes({this.id, this.firstName, this.lastName, this.photo});

  RecentLikes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    return data;
  }
}
