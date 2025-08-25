// To parse this JSON data, do
//
//     final avgPricesResponse = avgPricesResponseFromJson(jsonString);

import 'dart:convert';

AvgPricesResponse avgPricesResponseFromJson(String str) => AvgPricesResponse.fromJson(json.decode(str));

String avgPricesResponseToJson(AvgPricesResponse data) => json.encode(data.toJson());

class AvgPricesResponse {
  final List<CityPrices> cities;

  AvgPricesResponse({required this.cities});

  factory AvgPricesResponse.fromJson(Map<String, dynamic> json) {
    List<CityPrices> cityList = [];
    json.forEach((cityName, currencies) {
      cityList.add(CityPrices.fromJson(cityName, currencies));
    });
    return AvgPricesResponse(cities: cityList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    for (var city in cities) {
      data[city.cityName] = city.toJson();
    }
    return data;
  }
}

class CityPrices {
  final String cityName;
  final List<Map<String, Type>> currencies;

  CityPrices({required this.cityName, required this.currencies});

  factory CityPrices.fromJson(String name, Map<String, dynamic> json) {
    List<Map<String, Type>> currencyList = [];
    json.forEach((key, value) {
      currencyList.add({key: Type.fromJson(value)});
    });
    return CityPrices(cityName: name, currencies: currencyList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    for (var currencyMap in currencies) {
      currencyMap.forEach((key, value) {
        data[key] = value.toJson();
      });
    }
    return data;
  }
}

class Type {
  final int buy;
  final int sell;

  Type({required this.buy, required this.sell});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(buy: json['buy'] ?? 0, sell: json['sell'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'buy': buy, 'sell': sell};
  }
}

// class AvgPricesResponse {
//     Empty empty;
//     Map<String, Aed> avgPricesResponse;

//     AvgPricesResponse({
//         required this.empty,
//         required this.avgPricesResponse,
//     });

//     factory AvgPricesResponse.fromJson(Map<String, dynamic> json) => AvgPricesResponse(
//         empty: Empty.fromJson(json["حمص"]),
//         avgPricesResponse: Map.from(json["دمشق"]).map((k, v) => MapEntry<String, Aed>(k, Aed.fromJson(v))),
//     );

//     Map<String, dynamic> toJson() => {
//         "حمص": empty.toJson(),
//         "دمشق": Map.from(avgPricesResponse).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//     };
// }

// class Aed {
//     int buy;
//     int sell;

//     Aed({
//         required this.buy,
//         required this.sell,
//     });

//     factory Aed.fromJson(Map<String, dynamic> json) => Aed(
//         buy: json["buy"],
//         sell: json["sell"],
//     );

//     Map<String, dynamic> toJson() => {
//         "buy": buy,
//         "sell": sell,
//     };
// }

// class Empty {
//     Aed usd;
//     Aed eur;
//     Aed tl;
//     Aed aed;
//     Aed egp;
//     Aed sar;

//     Empty({
//         required this.usd,
//         required this.eur,
//         required this.tl,
//         required this.aed,
//         required this.egp,
//         required this.sar,
//     });

//     factory Empty.fromJson(Map<String, dynamic> json) => Empty(
//         usd: Aed.fromJson(json["usd"]),
//         eur: Aed.fromJson(json["eur"]),
//         tl: Aed.fromJson(json["tl"]),
//         aed: Aed.fromJson(json["AED"]),
//         egp: Aed.fromJson(json["EGP"]),
//         sar: Aed.fromJson(json["SAR"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "usd": usd.toJson(),
//         "eur": eur.toJson(),
//         "tl": tl.toJson(),
//         "AED": aed.toJson(),
//         "EGP": egp.toJson(),
//         "SAR": sar.toJson(),
//     };
// }
