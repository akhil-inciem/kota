class PollModel {
  bool? status;
  String? message;
  List<PollData>? data;

  PollModel({this.status, this.message, this.data});

  PollModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PollData>[];
      json['data'].forEach((v) {
        data!.add(new PollData.fromJson(v));
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

class PollData {
  String? id;
  String? title;
  String? discription;
  String? createdBy;
  String? pollFeild;
  String? expairydate;
  String? allowmultiple;
  String? createdAt;
  String? updateAt;
  bool? editable;
  ReactionCounts? reactionCounts;

  PollData(
      {this.id,
      this.title,
      this.discription,
      this.createdBy,
      this.pollFeild,
      this.expairydate,
      this.allowmultiple,
      this.createdAt,
      this.updateAt,
      this.editable,
      this.reactionCounts});

  PollData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    discription = json['discription'];
    createdBy = json['created_by'];
    pollFeild = json['poll_feild'];
    expairydate = json['expairydate'];
    allowmultiple = json['allowmultiple'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    editable = json['editable'];
    reactionCounts = json['reaction_counts'] != null
        ? new ReactionCounts.fromJson(json['reaction_counts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['discription'] = this.discription;
    data['created_by'] = this.createdBy;
    data['poll_feild'] = this.pollFeild;
    data['expairydate'] = this.expairydate;
    data['allowmultiple'] = this.allowmultiple;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['editable'] = this.editable;
    if (this.reactionCounts != null) {
      data['reaction_counts'] = this.reactionCounts!.toJson();
    }
    return data;
  }
}

class ReactionCounts {
  int? i2;
  int? i3;
  int? i4;
  int? hi;
  int? hello;
  int? testing12;
  int? testing234;
  int? test1;
  int? test2;
  int? weekly;
  int? biweekly;
  int? good;

  ReactionCounts(
      {this.i2,
      this.i3,
      this.i4,
      this.hi,
      this.hello,
      this.testing12,
      this.testing234,
      this.test1,
      this.test2,
      this.weekly,
      this.biweekly,
      this.good});

  ReactionCounts.fromJson(Map<String, dynamic> json) {
    i2 = json['2'];
    i3 = json['3'];
    i4 = json['4'];
    hi = json['hi'];
    hello = json['hello'];
    testing12 = json['testing12'];
    testing234 = json['testing234'];
    test1 = json['test1'];
    test2 = json['test2'];
    weekly = json['weekly'];
    biweekly = json['biweekly'];
    good = json['good'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['2'] = this.i2;
    data['3'] = this.i3;
    data['4'] = this.i4;
    data['hi'] = this.hi;
    data['hello'] = this.hello;
    data['testing12'] = this.testing12;
    data['testing234'] = this.testing234;
    data['test1'] = this.test1;
    data['test2'] = this.test2;
    data['weekly'] = this.weekly;
    data['biweekly'] = this.biweekly;
    data['good'] = this.good;
    return data;
  }
}
