// To parse this JSON data, do
//
//     final statusResponseModel = statusResponseModelFromJson(jsonString);

import 'dart:convert';

StatusResponseModel statusResponseModelFromJson(String str) => StatusResponseModel.fromJson(json.decode(str));

String statusResponseModelToJson(StatusResponseModel data) => json.encode(data.toJson());

class StatusResponseModel {
  String status;

  StatusResponseModel({required this.status});

  factory StatusResponseModel.fromJson(Map<String, dynamic> json) => StatusResponseModel(status: json["status"]);

  Map<String, dynamic> toJson() => {"status": status};
}
