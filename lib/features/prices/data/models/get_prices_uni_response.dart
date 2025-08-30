// To parse this JSON data, do
//
//     final getPricesUniResponse = getPricesUniResponseFromJson(jsonString);

import 'dart:convert';

List<GetPricesUniResponse> getPricesUniResponseFromJson(String str) =>
    List<GetPricesUniResponse>.from(json.decode(str).map((x) => GetPricesUniResponse.fromJson(x)));

String getPricesUniResponseToJson(List<GetPricesUniResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetPricesUniResponse {
  String cur1;
  String cur2;
  double sell;
  double buy;

  GetPricesUniResponse({required this.cur1, required this.cur2, required this.sell, required this.buy});

  factory GetPricesUniResponse.fromJson(Map<String, dynamic> json) => GetPricesUniResponse(
    cur1: json["cur1"],
    cur2: json["cur2"],
    sell: (json["sell"] as num).toDouble(),
    buy: (json["buy"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {"cur1": cur1, "cur2": cur2, "sell": sell, "buy": buy};
}
