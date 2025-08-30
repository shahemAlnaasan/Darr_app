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
  final List<Center> centers;

  CityPrices({required this.cityName, required this.centers});

  factory CityPrices.fromJson(String name, Map<String, dynamic> json) {
    List<Center> merkezList = [];
    json.forEach((merkezId, merkezData) {
      merkezList.add(Center.fromJson(merkezId, merkezData));
    });
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

class Center {
  final String id;
  final String centerName;
  final List<Currency> currencies;

  Center({required this.id, required this.centerName, required this.currencies});

  factory Center.fromJson(String id, Map<String, dynamic> json) {
    List<Currency> currencyList = [];
    json['currencies'].forEach((currencyCode, currencyData) {
      currencyList.add(Currency.fromJson(currencyCode, currencyData));
    });
    return Center(id: id, centerName: json['merkez_name'] ?? "", currencies: currencyList);
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
