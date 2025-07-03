class PollReactionModel {
  bool? status;
  String? message;
  int? totalVotes;  // new field
  List<ReactionData>? data;

  PollReactionModel({this.status, this.message, this.totalVotes, this.data});

  PollReactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalVotes = json['total_votes'];  // parse total_votes here
    if (json['data'] != null) {
      data = <ReactionData>[];
      json['data'].forEach((v) {
        data!.add(ReactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    json['status'] = status;
    json['message'] = message;
    json['total_votes'] = totalVotes;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}


class ReactionData {
  String? reaction;
  String? userId;
  String? createdAt;
  String? userName;
  String? userPhoto;

  ReactionData(
      {this.reaction,
      this.userId,
      this.createdAt,
      this.userName,
      this.userPhoto});

  ReactionData.fromJson(Map<String, dynamic> json) {
    reaction = json['reaction'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    userName = json['user_name'];
    userPhoto = json['user_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reaction'] = this.reaction;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['user_name'] = this.userName;
    data['user_photo'] = this.userPhoto;
    return data;
  }
}
