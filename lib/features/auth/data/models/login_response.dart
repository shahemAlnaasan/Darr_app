// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String status;
  int id;
  String name;

  LoginResponse({required this.status, required this.id, required this.name});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(status: json["status"], id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"status": status, "id": id, "name": name};
}
