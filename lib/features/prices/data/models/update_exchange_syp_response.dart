// To parse this JSON data, do
//
//     final updateExchangeSypResponse = updateExchangeSypResponseFromJson(jsonString);

import 'dart:convert';

UpdateExchangeSypResponse updateExchangeSypResponseFromJson(String str) =>
    UpdateExchangeSypResponse.fromJson(json.decode(str));

String updateExchangeSypResponseToJson(UpdateExchangeSypResponse data) => json.encode(data.toJson());

class UpdateExchangeSypResponse {
  String status;

  UpdateExchangeSypResponse({required this.status});

  factory UpdateExchangeSypResponse.fromJson(Map<String, dynamic> json) =>
      UpdateExchangeSypResponse(status: json["status"]);

  Map<String, dynamic> toJson() => {"status": status};
}
