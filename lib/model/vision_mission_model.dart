class VisionModel {
    VisionModel({
        required this.status,
        required this.message,
        required this.data,
    });

    final bool? status;
    final String? message;
    final List<VisionDatum> data;

    factory VisionModel.fromJson(Map<String, dynamic> json){ 
        return VisionModel(
            status: json["status"],
            message: json["message"],
            data: json["data"] == null ? [] : List<VisionDatum>.from(json["data"]!.map((x) => VisionDatum.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.map((x) => x?.toJson()).toList(),
    };

}

class VisionDatum {
    VisionDatum({
        required this.ssId,
        required this.siteTitle,
        required this.footerNote,
        required this.domain,
        required this.computerLogo,
        required this.mobileLogo,
        required this.favicon,
        required this.hotlineNumber,
        required this.email,
        required this.facebook,
        required this.twitter,
        required this.youtube,
        required this.instagram,
        required this.alternativeNumber,
        required this.address,
        required this.shortDescription,
        required this.mission,
        required this.missionFrontImage,
        required this.missionBackImage,
        required this.vision,
        required this.missionImage,
        required this.aboutUsBackImage,
        required this.memberLoginBgImage,
        required this.memberDashboardBgImage,
    });

    final String? ssId;
    final String? siteTitle;
    final String? footerNote;
    final String? domain;
    final String? computerLogo;
    final String? mobileLogo;
    final String? favicon;
    final String? hotlineNumber;
    final String? email;
    final String? facebook;
    final String? twitter;
    final String? youtube;
    final String? instagram;
    final String? alternativeNumber;
    final String? address;
    final String? shortDescription;
    final String? mission;
    final String? missionFrontImage;
    final String? missionBackImage;
    final String? vision;
    final dynamic missionImage;
    final String? aboutUsBackImage;
    final String? memberLoginBgImage;
    final String? memberDashboardBgImage;

    factory VisionDatum.fromJson(Map<String, dynamic> json){ 
        return VisionDatum(
            ssId: json["ss_id"],
            siteTitle: json["site_title"],
            footerNote: json["footer_note"],
            domain: json["domain"],
            computerLogo: json["computer_logo"],
            mobileLogo: json["mobile_logo"],
            favicon: json["favicon"],
            hotlineNumber: json["hotline_number"],
            email: json["email"],
            facebook: json["facebook"],
            twitter: json["twitter"],
            youtube: json["youtube"],
            instagram: json["instagram"],
            alternativeNumber: json["alternative_number"],
            address: json["address"],
            shortDescription: json["short_description"],
            mission: json["mission"],
            missionFrontImage: json["mission_front_image"],
            missionBackImage: json["mission_back_image"],
            vision: json["vision"],
            missionImage: json["mission_image"],
            aboutUsBackImage: json["about_us_back_image"],
            memberLoginBgImage: json["member_login_bg_image"],
            memberDashboardBgImage: json["member_dashboard_bg_image"],
        );
    }

    Map<String, dynamic> toJson() => {
        "ss_id": ssId,
        "site_title": siteTitle,
        "footer_note": footerNote,
        "domain": domain,
        "computer_logo": computerLogo,
        "mobile_logo": mobileLogo,
        "favicon": favicon,
        "hotline_number": hotlineNumber,
        "email": email,
        "facebook": facebook,
        "twitter": twitter,
        "youtube": youtube,
        "instagram": instagram,
        "alternative_number": alternativeNumber,
        "address": address,
        "short_description": shortDescription,
        "mission": mission,
        "mission_front_image": missionFrontImage,
        "mission_back_image": missionBackImage,
        "vision": vision,
        "mission_image": missionImage,
        "about_us_back_image": aboutUsBackImage,
        "member_login_bg_image": memberLoginBgImage,
        "member_dashboard_bg_image": memberDashboardBgImage,
    };

}