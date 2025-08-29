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
    json.forEach((cityName, id) {
      cityList.add(CityPrices.fromJson(cityName, id));
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
