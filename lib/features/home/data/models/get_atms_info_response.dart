// To parse this JSON data, do
//
//     final getAtmsInfoResponse = getAtmsInfoResponseFromJson(jsonString);

import 'dart:convert';

GetAtmsInfoResponse getAtmsInfoResponseFromJson(String str) => GetAtmsInfoResponse.fromJson(json.decode(str));

String getAtmsInfoResponseToJson(GetAtmsInfoResponse data) => json.encode(data.toJson());

class GetAtmsInfoResponse {
  String status;
  Info info;

  GetAtmsInfoResponse({required this.status, required this.info});

  factory GetAtmsInfoResponse.fromJson(Map<String, dynamic> json) =>
      GetAtmsInfoResponse(status: json["status"], info: Info.fromJson(json["info"]));

  Map<String, dynamic> toJson() => {"status": status, "info": info.toJson()};
}

class Info {
  String name;
  String address;
  String phone;
  String img;

  Info({required this.name, required this.address, required this.phone, required this.img});

  factory Info.fromJson(Map<String, dynamic> json) =>
      Info(name: json["name"], address: json["address"], phone: json["phone"], img: json["img"] ?? "");

  Map<String, dynamic> toJson() => {"name": name, "address": address, "phone": phone};
}
