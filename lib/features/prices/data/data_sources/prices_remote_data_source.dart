import 'package:dartz/dartz.dart';
import 'package:exchange_darr/core/config/endpoints.dart';
import 'package:exchange_darr/core/network/api_handler.dart';
import 'package:exchange_darr/core/network/exceptions.dart';
import 'package:exchange_darr/core/network/http_client.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:injectable/injectable.dart';
import '../models/avg_prices_response.dart';

@injectable
class PricesRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  PricesRemoteDataSource({required this.httpClient});

  Future<Either<Failure, AvgPricesResponse>> avgPrices() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.avgPrices),
      fromJson: (json) => AvgPricesResponse.fromJson(json),
      validateApi: false,
    );
  }

  Future<Either<Failure, GetPricesResponse>> getPrices() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getPrices),
      fromJson: (json) => GetPricesResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetPricesResponse>> getUsdPrices() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getUsdPrices),
      fromJson: (json) => GetPricesResponse.fromJson(json),
      validateApi: false,
    );
  }
}
