part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final String? errorMessage;
  final Status? loginStatus;
  final LoginResponse? loginResponse;
  const AuthState({this.errorMessage, this.loginStatus, this.loginResponse});

  AuthState copyWith({String? errorMessage, Status? loginStatus, LoginResponse? loginResponse}) {
    return AuthState(
      errorMessage: errorMessage ?? this.errorMessage,
      loginStatus: loginStatus ?? this.loginStatus,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }

  @override
  List<Object?> get props => [errorMessage, loginStatus, loginResponse];
}
