// To parse this JSON data, do
//
//     final checkActivationStatusResponse = checkActivationStatusResponseFromJson(jsonString);

import 'dart:convert';

CheckActivationStatusResponse checkActivationStatusResponseFromJson(String str) =>
    CheckActivationStatusResponse.fromJson(json.decode(str));

String checkActivationStatusResponseToJson(CheckActivationStatusResponse data) => json.encode(data.toJson());

class CheckActivationStatusResponse {
  String status;
  String info;

  CheckActivationStatusResponse({required this.status, required this.info});

  factory CheckActivationStatusResponse.fromJson(Map<String, dynamic> json) =>
      CheckActivationStatusResponse(status: json["status"], info: json["info"]);

  Map<String, dynamic> toJson() => {"status": status, "info": info};
}
