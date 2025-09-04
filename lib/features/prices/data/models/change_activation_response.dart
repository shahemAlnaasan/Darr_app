// To parse this JSON data, do
//
//     final changeActivationResponse = changeActivationResponseFromJson(jsonString);

import 'dart:convert';

ChangeActivationResponse changeActivationResponseFromJson(String str) =>
    ChangeActivationResponse.fromJson(json.decode(str));

String changeActivationResponseToJson(ChangeActivationResponse data) => json.encode(data.toJson());

class ChangeActivationResponse {
  int status;

  ChangeActivationResponse({required this.status});

  factory ChangeActivationResponse.fromJson(Map<String, dynamic> json) =>
      ChangeActivationResponse(status: json["status"]);

  Map<String, dynamic> toJson() => {"status": status};
}
