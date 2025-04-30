class UserResponse {
  final bool status;
  final String message;
  final User user;

  UserResponse({
    required this.status,
    required this.message,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'user': user.toJson(),
      };
}

class User {
  final String id;
  final String aiotaMembershipNo;
  final String kbaiotaMembershipNo;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String photo;
  final String primaryNumber;
  final String secondaryNumber;
  final String email;
  final String address;
  final String pincode;
  final String idProof;
  final String signDate;
  final String graduationCertificate;
  final String pgCertificate;
  final String aiotaCertificate;

  User({
    required this.id,
    required this.aiotaMembershipNo,
    required this.kbaiotaMembershipNo,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.photo,
    required this.primaryNumber,
    required this.secondaryNumber,
    required this.email,
    required this.address,
    required this.pincode,
    required this.idProof,
    required this.signDate,
    required this.graduationCertificate,
    required this.pgCertificate,
    required this.aiotaCertificate,
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
}
