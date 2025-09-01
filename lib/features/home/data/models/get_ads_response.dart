// To parse this JSON data, do
//
//     final getAdsResponse = getAdsResponseFromJson(jsonString);

import 'dart:convert';

GetAdsResponse getAdsResponseFromJson(String str) => GetAdsResponse.fromJson(json.decode(str));

String getAdsResponseToJson(GetAdsResponse data) => json.encode(data.toJson());

class GetAdsResponse {
  String status;
  List<Ad> ads;

  GetAdsResponse({required this.status, required this.ads});

  factory GetAdsResponse.fromJson(Map<String, dynamic> json) =>
      GetAdsResponse(status: json["status"], ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))));

  Map<String, dynamic> toJson() => {"status": status, "ads": List<dynamic>.from(ads.map((x) => x.toJson()))};
}

class Ad {
  String title;
  String txt;
  String img;
  String map;

  Ad({required this.title, required this.txt, required this.img, required this.map});

  factory Ad.fromJson(Map<String, dynamic> json) =>
      Ad(title: json["title"] ?? "", txt: json["txt"] ?? "", img: json["img"] ?? "", map: json["map"] ?? "");

  Map<String, dynamic> toJson() => {"title": title, "txt": txt, "img": img, "map": map};
}
