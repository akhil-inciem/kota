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
        data!.add(ForumData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class ForumData {
  String? id;
  String? title;
  String? content;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? photo;
  String? likeCount;
  String? commentCount;
  List<String>? images;
  List<RecentLike>? recentLikes;
  List<Comments>? comments;

  ForumData({
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.photo,
    this.likeCount,
    this.commentCount,
    this.images,
    this.recentLikes,
    this.comments,
  });

  ForumData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    images = json['images']?.cast<String>() ?? [];

     if (json['recent_likes'] != null) {
    recentLikes = <RecentLike>[];
    json['recent_likes'].forEach((v) {
      recentLikes!.add(RecentLike.fromJson(v));
    });
  }

    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'first_name': firstName,
      'last_name': lastName,
      'photo': photo,
      'like_count': likeCount,
      'comment_count': commentCount,
      'images': images,
      'recent_likes': recentLikes?.map((v) => v.toJson()).toList(),
      'comments': comments?.map((v) => v.toJson()).toList(),
    };
  }
}

class Comments {
  String? id;
  String? content;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? photo;
  String? likeCount;
  List<Replies>? replies;

  Comments({
    this.id,
    this.content,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.photo,
    this.likeCount,
    this.replies,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    likeCount = json['like_count'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt,
      'first_name': firstName,
      'last_name': lastName,
      'photo': photo,
      'like_count': likeCount,
      'replies': replies?.map((v) => v.toJson()).toList(),
    };
  }
}
class RecentLike {
  String? id;
  String? firstName;
  String? lastName;
  String? photo;

  RecentLike({this.id, this.firstName, this.lastName, this.photo});

  RecentLike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'photo': photo,
    };
  }
}
class Replies {
  String? id;
  String? content;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? photo;
  String? likeCount;

  Replies({
    this.id,
    this.content,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.photo,
    this.likeCount,
  });

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    likeCount = json['like_count'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt,
      'first_name': firstName,
      'last_name': lastName,
      'photo': photo,
      'like_count': likeCount,
    };
  }
}
