import 'package:dartz/dartz.dart';
import 'package:exchange_darr/core/config/endpoints.dart';
import 'package:exchange_darr/core/network/api_handler.dart';
import 'package:exchange_darr/core/network/exceptions.dart';
import 'package:exchange_darr/core/network/http_client.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../models/login_response.dart';

@injectable
class AuthRemoteDataSource with ApiHandler {
  final HTTPClient httpClient;

  AuthRemoteDataSource({required this.httpClient});

  Future<Either<Failure, LoginResponse>> login({required LoginParams params}) async {
    return handleApiCall(
      apiCall: () => httpClient.post(AppEndPoint.login, data: params.getBody()),
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }
}
