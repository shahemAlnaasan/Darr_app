// To parse this JSON data, do
//
//     final showMsgResponse = showMsgResponseFromJson(jsonString);

import 'dart:convert';

ShowMsgResponse showMsgResponseFromJson(String str) => ShowMsgResponse.fromJson(json.decode(str));

String showMsgResponseToJson(ShowMsgResponse data) => json.encode(data.toJson());

class ShowMsgResponse {
  String status;
  List<Msg> msgs;

  ShowMsgResponse({required this.status, required this.msgs});

  factory ShowMsgResponse.fromJson(Map<String, dynamic> json) =>
      ShowMsgResponse(status: json["status"], msgs: List<Msg>.from(json["msgs"].map((x) => Msg.fromJson(x))));

  Map<String, dynamic> toJson() => {"status": status, "msgs": List<dynamic>.from(msgs.map((x) => x.toJson()))};
}

class Msg {
  int id;
  String msg;

  Msg({required this.id, required this.msg});

  factory Msg.fromJson(Map<String, dynamic> json) => Msg(id: json["id"], msg: json["msg"]);

  Map<String, dynamic> toJson() => {"id": id, "msg": msg};
}
