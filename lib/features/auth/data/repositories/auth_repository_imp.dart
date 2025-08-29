import 'package:exchange_darr/common/consts/typedef.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../models/login_response.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImp({required this.authRemoteDataSource});

  @override
  DataResponse<LoginResponse> login({required LoginParams params}) {
    return authRemoteDataSource.login(params: params);
  }
}
