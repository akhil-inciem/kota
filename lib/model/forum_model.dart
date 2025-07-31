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
  String? createdId;
  String? title;
  String? guestUserId;
  String? content;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? photo;
  String? userType;
  int? likeCount;
  int? commentCount;
  String? contentSnippet;
  List<String>? images;
  List<RecentLike>? recentLikes;
  bool? isLiked;
  List<Comments>? comments;

  ForumData({
    this.id,
      this.title,
      this.createdId,
      this.guestUserId,
      this.content,
      this.createdAt,
      this.firstName,
      this.lastName,
      this.photo,
      this.userType,
      this.likeCount,
      this.commentCount,
      this.contentSnippet,
      this.images,
      this.recentLikes,
      this.isLiked,
      this.comments
  });

  ForumData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdId = json['created_id'];
    guestUserId = json['guest_user_id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    userType = json['user_type'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    contentSnippet = json['content_snippet'];
    images = json['images'].cast<String>();
    if (json['recent_likes'] != null) {
      recentLikes = <RecentLike>[];
      json['recent_likes'].forEach((v) {
        recentLikes!.add(new RecentLike.fromJson(v));
      });
    }
    isLiked = json['is_liked'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_id'] = this.createdId;
    data['guest_user_id'] =this.guestUserId;
    data['title'] = this.title;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_type'] = this.userType;
    data['photo'] = this.photo;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['content_snippet'] = this.contentSnippet;
    data['images'] = this.images;
    if (this.recentLikes != null) {
      data['recent_likes'] = this.recentLikes!.map((v) => v.toJson()).toList();
    }
    data['is_liked'] = this.isLiked;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  ForumData copyWith({
  String? id,
  String? createdId,
  String? title,
  String? guestUserId,
  String? content,
  String? createdAt,
  String? firstName,
  String? lastName,
  String? photo,
  String? userType,
  int? likeCount,
  int? commentCount,
  String? contentSnippet,
  List<String>? images,
  List<RecentLike>? recentLikes,
  bool? isLiked,
  List<Comments>? comments,
}) {
  return ForumData(
    id: id ?? this.id,
    createdId: createdId ?? this.createdId,
    guestUserId: guestUserId ?? this.guestUserId,
    title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    photo: photo ?? this.photo,
    userType: userType ?? this.userType,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount ?? this.commentCount,
    contentSnippet: contentSnippet ?? this.contentSnippet,
    images: images ?? this.images,
    recentLikes: recentLikes ?? this.recentLikes,
    isLiked: isLiked ?? this.isLiked,
    comments: comments ?? this.comments,
  );
}

}
class Comments {
  String? id;
  String? userId;
  String? content;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? photo;
  String? userType;
  String? likeCount;
  bool? isLiked;
  List<Replies>? replies;

  Comments(
      {this.id,
      this.userId,
      this.content,
      this.createdAt,
      this.firstName,
      this.lastName,
      this.photo,
      this.userType,
      this.likeCount,
      this.isLiked,
      this.replies});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    userType = json['user_type'];
    likeCount = json['like_count'];
    isLiked = json['is_liked'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['user_type'] = this.userType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    data['like_count'] = this.likeCount;
    data['is_liked'] = this.isLiked;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
extension CommentsCopyWith on Comments {
  Comments copyWith({
    String? id,
    String? userId,
    String? content,
    String? userType,
    String? createdAt,
    String? firstName,
    String? lastName,
    String? photo,
    String? likeCount,
    bool? isLiked,
    List<Replies>? replies,
  }) {
    return Comments(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photo: photo ?? this.photo,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }
}

extension RepliesCopyWith on Replies {
  Replies copyWith({
    String? id,
    String? userId,
    String? content,
    String? createdAt,
    String? firstName,
    String? lastName,
    String? photo,
    String? userType,
    String? likeCount,
    bool? isLiked,
    String? commentId,
  }) {
    return Replies(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photo: photo ?? this.photo,
      userType: userType ?? this.userType,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      commentId: commentId ?? this.commentId,
    );
  }
}

class Replies {
  String? id;
  String? userId;
  String? content;
  String? createdAt;
  String? firstName;
  String? lastName;
  String? userType;
  String? photo;
  String? likeCount;
  bool? isLiked;
  String? commentId;

  Replies(
      {this.id,
      this.userId,
      this.content,
      this.createdAt,
      this.firstName,
      this.lastName,
      this.userType,
      this.photo,
      this.likeCount,
      this.isLiked,
      this.commentId});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userType = json['user_type'];
    photo = json['photo'];
    likeCount = json['like_count'];
    isLiked = json['is_liked'];
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['user_type'] = this.userType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    data['like_count'] = this.likeCount;
    data['is_liked'] = this.isLiked;
    data['comment_id'] = this.commentId;
    return data;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    return data;
  }
}