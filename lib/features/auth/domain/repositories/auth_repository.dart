import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:exchange_darr/features/auth/data/models/login_response.dart';
import 'package:exchange_darr/features/auth/domain/use_cases/login_usecase.dart';

abstract class AuthRepository {
  DataResponse<LoginResponse> login({required LoginParams params});
}
