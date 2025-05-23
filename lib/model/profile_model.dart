class UserResponse {
  final bool? status;
  final String? message;
  final User? user;

  UserResponse({
    this.status,
    this.message,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      message: json['message'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'user': user?.toJson(),
      };
}

class User {
  final String? id;
  final String? aiotaMembershipNo;
  final String? kbaiotaMembershipNo;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? photo;
  final String? primaryNumber;
  final String? secondaryNumber;
  final String? email;
  final String? address;
  final String? pincode;
  final String? idProof;
  final String? signDate;
  final String? graduationCertificate;
  final String? pgCertificate;
  final String? aiotaCertificate;

  User({
    this.id,
    this.aiotaMembershipNo,
    this.kbaiotaMembershipNo,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.photo,
    this.primaryNumber,
    this.secondaryNumber,
    this.email,
    this.address,
    this.pincode,
    this.idProof,
    this.signDate,
    this.graduationCertificate,
    this.pgCertificate,
    this.aiotaCertificate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      aiotaMembershipNo: json['aiota_membership_no'],
      kbaiotaMembershipNo: json['kbaiota_membership_no'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: json['birth_date'],
      photo: json['photo'],
      primaryNumber: json['primary_number'],
      secondaryNumber: json['secondary_number'],
      email: json['email'],
      address: json['address'],
      pincode: json['pincode'],
      idProof: json['id_proof'],
      signDate: json['sign_date'],
      graduationCertificate: json['graduation_certificate'],
      pgCertificate: json['pg_certificate'],
      aiotaCertificate: json['aiota_certificate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'aiota_membership_no': aiotaMembershipNo,
        'kbaiota_membership_no': kbaiotaMembershipNo,
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
        'photo': photo,
        'primary_number': primaryNumber,
        'secondary_number': secondaryNumber,
        'email': email,
        'address': address,
        'pincode': pincode,
        'id_proof': idProof,
        'sign_date': signDate,
        'graduation_certificate': graduationCertificate,
        'pg_certificate': pgCertificate,
        'aiota_certificate': aiotaCertificate,
      };

      User copyWith({
  String? id,
  String? aiotaMembershipNo,
  String? kbaiotaMembershipNo,
  String? firstName,
  String? lastName,
  String? birthDate,
  String? photo,
  String? primaryNumber,
  String? secondaryNumber,
  String? email,
  String? address,
  String? pincode,
  String? idProof,
  String? signDate,
  String? graduationCertificate,
  String? pgCertificate,
  String? aiotaCertificate,
}) {
  return User(
    id: id ?? this.id,
    aiotaMembershipNo: aiotaMembershipNo ?? this.aiotaMembershipNo,
    kbaiotaMembershipNo: kbaiotaMembershipNo ?? this.kbaiotaMembershipNo,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    birthDate: birthDate ?? this.birthDate,
    photo: photo ?? this.photo,
    primaryNumber: primaryNumber ?? this.primaryNumber,
    secondaryNumber: secondaryNumber ?? this.secondaryNumber,
    email: email ?? this.email,
    address: address ?? this.address,
    pincode: pincode ?? this.pincode,
    idProof: idProof ?? this.idProof,
    signDate: signDate ?? this.signDate,
    graduationCertificate: graduationCertificate ?? this.graduationCertificate,
    pgCertificate: pgCertificate ?? this.pgCertificate,
    aiotaCertificate: aiotaCertificate ?? this.aiotaCertificate,
  );
}

}
