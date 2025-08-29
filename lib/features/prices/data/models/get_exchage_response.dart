// To parse this JSON data, do
//
//     final getExchangeResponse = getExchangeResponseFromJson(jsonString);

import 'dart:convert';

// GetExchangeResponse getExchangeResponseFromJson(String str) => GetExchangeResponse.fromJson(json.decode(str) , );

String getExchangeResponseToJson(GetExchangeResponse data) => json.encode(data.toJson());

class GetExchangeResponse {
  String status;
  List<Price> prices;

  GetExchangeResponse({required this.status, required this.prices});

  factory GetExchangeResponse.fromJson(Map<String, dynamic> json, bool isSyp) => GetExchangeResponse(
    status: json["status"],
    prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x, isSyp))),
  );

  Map<String, dynamic> toJson() => {"status": status, "prices": List<dynamic>.from(prices.map((x) => x.toJson()))};
}

class Price {
  String cur;
  String buy;
  String sell;
  bool isSyp;

  Price({required this.cur, required this.buy, required this.sell, required this.isSyp});

  factory Price.fromJson(Map<String, dynamic> json, bool isSyp) =>
      Price(cur: json["cur"], buy: json["buy"], sell: json["sell"], isSyp: isSyp);

  Map<String, dynamic> toJson() => {"cur": cur, "buy": buy, "sell": sell};
}
