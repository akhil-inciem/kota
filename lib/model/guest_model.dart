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
  String? fullName;
  String? mailId;

  Data({this.fullName, this.mailId});

  Data.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    mailId = json['mail_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['mail_id'] = this.mailId;
    return data;
  }
}
