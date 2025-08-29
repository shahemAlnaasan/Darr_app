import 'package:dartz/dartz.dart';
import 'package:exchange_darr/core/config/endpoints.dart';
import 'package:exchange_darr/core/network/api_handler.dart';
import 'package:exchange_darr/core/network/exceptions.dart';
import 'package:exchange_darr/core/network/http_client.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_usd_usecase.dart';
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

  Future<Either<Failure, GetExchangeResponse>> getExchageSyp({required GetExchangeSypParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getExchageSyp, data: params.getBody()),
      fromJson: (json) => GetExchangeResponse.fromJson(json, true),
    );
  }

  Future<Either<Failure, GetExchangeResponse>> getExchageUsd({required GetExchangeUsdParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getExchageUsd, data: params.getBody()),
      fromJson: (json) => GetExchangeResponse.fromJson(json, false),
    );
  }
}
