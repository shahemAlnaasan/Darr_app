// To parse this JSON data, do
//
//     final getCursResponse = getCursResponseFromJson(jsonString);

import 'dart:convert';

GetCursResponse getCursResponseFromJson(String str) => GetCursResponse.fromJson(json.decode(str));

String getCursResponseToJson(GetCursResponse data) => json.encode(data.toJson());

class GetCursResponse {
  String status;
  List<Cur> curs;

  GetCursResponse({required this.status, required this.curs});

  factory GetCursResponse.fromJson(Map<String, dynamic> json) =>
      GetCursResponse(status: json["status"], curs: List<Cur>.from(json["curs"].map((x) => Cur.fromJson(x))));

  Map<String, dynamic> toJson() => {"status": status, "curs": List<dynamic>.from(curs.map((x) => x.toJson()))};
}

class Cur {
  String id;
  String name;

  Cur({required this.id, required this.name});

  factory Cur.fromJson(Map<String, dynamic> json) => Cur(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
