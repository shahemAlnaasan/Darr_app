// To parse this JSON data, do
//
//     final getCompanyInfoResponse = getCompanyInfoResponseFromJson(jsonString);

import 'dart:convert';

GetCompanyInfoResponse getCompanyInfoResponseFromJson(String str) => GetCompanyInfoResponse.fromJson(json.decode(str));

String getCompanyInfoResponseToJson(GetCompanyInfoResponse data) => json.encode(data.toJson());

class GetCompanyInfoResponse {
  String status;
  Info info;

  GetCompanyInfoResponse({required this.status, required this.info});

  factory GetCompanyInfoResponse.fromJson(Map<String, dynamic> json) =>
      GetCompanyInfoResponse(status: json["status"], info: Info.fromJson(json["info"]));

  Map<String, dynamic> toJson() => {"status": status, "info": info.toJson()};
}

class Info {
  String facebook;
  String telegram;
  String whatsapp;
  String aboutus;
  String share;

  Info({
    required this.facebook,
    required this.telegram,
    required this.whatsapp,
    required this.aboutus,
    required this.share,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    facebook: json["facebook"] ?? "",
    telegram: json["telegram"] ?? "",
    whatsapp: json["whatsapp"] ?? "",
    aboutus: json["aboutus"] ?? "",
    share: json["share"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "facebook": facebook,
    "telegram": telegram,
    "whatsapp": whatsapp,
    "aboutus": aboutus,
    "share": share,
  };
}
