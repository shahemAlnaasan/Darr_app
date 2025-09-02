import 'package:dartz/dartz.dart';
import 'package:exchange_darr/core/config/endpoints.dart';
import 'package:exchange_darr/core/network/api_handler.dart';
import 'package:exchange_darr/core/network/exceptions.dart';
import 'package:exchange_darr/core/network/http_client.dart';
import 'package:exchange_darr/features/home/data/models/get_atms_info_response.dart';
import 'package:exchange_darr/features/home/data/models/get_company_info_response.dart';
import 'package:exchange_darr/features/home/domain/use_cases/get_atms_info_usecase.dart';
import 'package:injectable/injectable.dart';
import '../models/get_ads_response.dart';

@injectable
class HomeRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  HomeRemoteDataSource({required this.httpClient});

  Future<Either<Failure, GetAdsResponse>> getAds() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getAds),
      fromJson: (json) => GetAdsResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetAtmsInfoResponse>> getAtmsInfo({required GetAtmsInfoParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getAtmsInfo, data: params.getBody()),
      fromJson: (json) => GetAtmsInfoResponse.fromJson(json),
    );
  }

  Future<Either<Failure, GetCompanyInfoResponse>> getCompanyInfo() async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.getCompanyInfo),
      fromJson: (json) => GetCompanyInfoResponse.fromJson(json),
    );
  }
}
