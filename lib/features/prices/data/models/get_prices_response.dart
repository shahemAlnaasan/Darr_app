// To parse this JSON data, do
//
//     final avgPricesResponse = avgPricesResponseFromJson(jsonString);

import 'dart:convert';

GetPricesResponse getPricesResponseFromJson(String str) => GetPricesResponse.fromJson(json.decode(str));

String getPricesResponseToJson(GetPricesResponse data) => json.encode(data.toJson());

class GetPricesResponse {
  final List<CityPrices> cities;

  GetPricesResponse({required this.cities});

  factory GetPricesResponse.fromJson(Map<String, dynamic> json) {
    List<CityPrices> cityList = [];
    json.forEach((cityName, merkezData) {
      cityList.add(CityPrices.fromJson(cityName, merkezData));
    });
    return GetPricesResponse(cities: cityList);
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
  final List<CenterData> centers;

  CityPrices({required this.cityName, required this.centers});

  factory CityPrices.fromJson(String name, dynamic json) {
    List<CenterData> merkezList = [];

    if (json is Map<String, dynamic>) {
      // Normal case: city has centers
      json.forEach((merkezId, merkezData) {
        merkezList.add(CenterData.fromJson(merkezId, merkezData));
      });
    } else if (json is List) {
      // Empty or unexpected array → treat as no centers
      merkezList = [];
    }

    return CityPrices(cityName: name, centers: merkezList);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    for (var center in centers) {
      data[center.id] = center.toJson();
    }
    return data;
  }
}

class CenterData {
  final String id;
  final String centerName;
  final String centerImg;
  final List<Currency> currencies;

  CenterData({required this.id, required this.centerName, required this.currencies, required this.centerImg});

  factory CenterData.fromJson(String id, Map<String, dynamic> json) {
    List<Currency> currencyList = [];
    json['currencies'].forEach((currencyCode, currencyData) {
      currencyList.add(Currency.fromJson(currencyCode, currencyData));
    });
    return CenterData(
      id: id,
      centerName: json['merkez_name'] ?? "",
      centerImg: json['merkez_logo'],
      currencies: currencyList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> currenciesJson = {};
    for (var currency in currencies) {
      currenciesJson[currency.code] = currency.toJson();
    }
    return {"merkez_name": centerName, "currencies": currenciesJson};
  }
}

class Currency {
  final String code;
  final String currencyName;
  final String buy;
  final String sell;

  Currency({required this.code, required this.currencyName, required this.buy, required this.sell});

  factory Currency.fromJson(String code, Map<String, dynamic> json) {
    return Currency(
      code: code,
      currencyName: json['currency_name'] ?? "",
      buy: json['buy']?.toString() ?? "0",
      sell: json['sell']?.toString() ?? "0",
    );
  }

  Map<String, dynamic> toJson() => {"currency_name": currencyName, "buy": buy, "sell": sell};
}
