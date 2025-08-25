import 'package:dartz/dartz.dart';
import 'package:exchange_darr/core/config/endpoints.dart';
import 'package:exchange_darr/core/network/api_handler.dart';
import 'package:exchange_darr/core/network/exceptions.dart';
import 'package:exchange_darr/core/network/http_client.dart';
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
}
