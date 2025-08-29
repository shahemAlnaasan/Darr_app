import '../../../../common/consts/typedef.dart';
import '../../data/models/login_response.dart';
import '../repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUsecase {
  final AuthRepository authRepository;

  LoginUsecase({required this.authRepository});

  DataResponse<LoginResponse> call({required LoginParams params}) {
    return authRepository.login(params: params);
  }
}

class LoginParams with Params {
  final String username;
  final String password;

  LoginParams({required this.username, required this.password});

  @override
  BodyMap getBody() => {
    "username": username,
    "password": password,
  };
}
