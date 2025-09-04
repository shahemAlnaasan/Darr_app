import 'package:dartz/dartz.dart';
import 'package:exchange_darr/core/config/endpoints.dart';
import 'package:exchange_darr/core/models/status_response_model.dart';
import 'package:exchange_darr/core/network/api_handler.dart';
import 'package:exchange_darr/core/network/exceptions.dart';
import 'package:exchange_darr/core/network/http_client.dart';
import 'package:exchange_darr/features/prices/data/models/check_activation_status_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_uni_response.dart';
import 'package:exchange_darr/features/prices/data/models/show_msg_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/change_activation_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/check_activation_status_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/delete_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_usd_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/show_msg_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/update_exchange_syp_usecase.dart';
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
      validateApi: false,
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

  Future<Either<Failure, GetCursResponse>> getCurs() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getCurs),
      fromJson: (json) => GetCursResponse.fromJson(json),
    );
  }

  Future<Either<Failure, StatusResponseModel>> addExchangeUsd({required AddExchangeParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.addExchangeUsd, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, StatusResponseModel>> addExchangeSyp({required AddExchangeParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.addExchangeSyp, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, StatusResponseModel>> updateExchangeSyp({required UpdateExchangeParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.updateExchangeSyp, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, StatusResponseModel>> updateExchangeUsd({required UpdateExchangeParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.updateExchangeUsd, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, List<GetPricesUniResponse>>> getPricesUni() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getPricesUni),
      fromJson: (json) => (json as List).map((e) => GetPricesUniResponse.fromJson(e)).toList(),
      validateApi: false,
    );
  }

  Future<Either<Failure, StatusResponseModel>> changeActivation({required ChangeActivationParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.changeActivation, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, StatusResponseModel>> addMsg({required AddMsgParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.addMsg, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, ShowMsgResponse>> showMsg({required ShowMsgParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.showMsg, data: params.getBody()),
      fromJson: (json) => ShowMsgResponse.fromJson(json),
    );
  }

  Future<Either<Failure, StatusResponseModel>> deleteMsg({required DeleteMsgParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.deleteMsg, data: params.getBody()),
      fromJson: (json) => StatusResponseModel.fromJson(json),
    );
  }

  Future<Either<Failure, CheckActivationStatusResponse>> checkActivationStatus({
    required CheckActivationStatusParams params,
  }) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.checkActivationStatus, data: params.getBody()),
      fromJson: (json) => CheckActivationStatusResponse.fromJson(json),
    );
  }
}
