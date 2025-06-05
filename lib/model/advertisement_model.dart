class AdvertisementModel {
  bool? status;
  String? messege;
  Data? data;

  AdvertisementModel({this.status, this.messege, this.data});

  AdvertisementModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messege = json['messege'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messege'] = this.messege;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Advertisements>? advertisements;

  Data({this.advertisements});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['advertisements'] != null) {
      advertisements = <Advertisements>[];
      json['advertisements'].forEach((v) {
        advertisements!.add(new Advertisements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.advertisements != null) {
      data['advertisements'] =
          this.advertisements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Advertisements {
  String? advertisementId;
  String? package;
  String? advertisementFrom;
  String? advertisementTo;
  String? institutionName;
  String? website;
  String? cpname;
  String? institutionAddress;
  String? contactPersonPhone;
  String? designation;
  String? contactPersonEmail;
  String? registrationType;
  String? registrationCertificate;
  String? status;
  String? addedOn;
  String? addedBy;
  String? advtImage;
  String? licenseCopy;
  String? institutionHead;
  String? emailVerification;
  String? paymentStatus;

  Advertisements(
      {this.advertisementId,
      this.package,
      this.advertisementFrom,
      this.advertisementTo,
      this.institutionName,
      this.website,
      this.cpname,
      this.institutionAddress,
      this.contactPersonPhone,
      this.designation,
      this.contactPersonEmail,
      this.registrationType,
      this.registrationCertificate,
      this.status,
      this.addedOn,
      this.addedBy,
      this.advtImage,
      this.licenseCopy,
      this.institutionHead,
      this.emailVerification,
      this.paymentStatus});

  Advertisements.fromJson(Map<String, dynamic> json) {
    advertisementId = json['advertisement_id'];
    package = json['package'];
    advertisementFrom = json['advertisement_from'];
    advertisementTo = json['advertisement_to'];
    institutionName = json['institution_name'];
    website = json['website'];
    cpname = json['cpname'];
    institutionAddress = json['institution_address'];
    contactPersonPhone = json['contact_person_phone'];
    designation = json['designation'];
    contactPersonEmail = json['contact_person_email'];
    registrationType = json['registration_type'];
    registrationCertificate = json['registration_certificate'];
    status = json['status'];
    addedOn = json['added_on'];
    addedBy = json['added_by'];
    advtImage = json['advt_image'];
    licenseCopy = json['license_copy'];
    institutionHead = json['institution_head'];
    emailVerification = json['email_verification'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advertisement_id'] = this.advertisementId;
    data['package'] = this.package;
    data['advertisement_from'] = this.advertisementFrom;
    data['advertisement_to'] = this.advertisementTo;
    data['institution_name'] = this.institutionName;
    data['website'] = this.website;
    data['cpname'] = this.cpname;
    data['institution_address'] = this.institutionAddress;
    data['contact_person_phone'] = this.contactPersonPhone;
    data['designation'] = this.designation;
    data['contact_person_email'] = this.contactPersonEmail;
    data['registration_type'] = this.registrationType;
    data['registration_certificate'] = this.registrationCertificate;
    data['status'] = this.status;
    data['added_on'] = this.addedOn;
    data['added_by'] = this.addedBy;
    data['advt_image'] = this.advtImage;
    data['license_copy'] = this.licenseCopy;
    data['institution_head'] = this.institutionHead;
    data['email_verification'] = this.emailVerification;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}
