class GuestModel {
  bool? status;
  String? message;
  Data? data;

  GuestModel({this.status, this.message, this.data});

  GuestModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  bool? isGuest;
  bool? isAgree;
  bool? isDeleted;

  Data({this.id, this.isGuest, this.isAgree, this.isDeleted});

  Data.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    isGuest = json['isguest'];
    isAgree = json['isAgree'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isguest'] = isGuest;
    data['isAgree'] = isAgree;
    data['isDeleted'] = isDeleted;
    return data;
  }
}

