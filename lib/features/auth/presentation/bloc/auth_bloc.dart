import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/auth/data/models/login_response.dart';
import 'package:exchange_darr/features/auth/domain/use_cases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  AuthBloc({required this.loginUsecase}) : super(AuthState()) {
    on<LoginEvent>(_onLoginEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: Status.loading));
    final result = await loginUsecase(params: event.params);
    result.fold(
      (left) {
        emit(state.copyWith(loginStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.hasLogin, value: true);
        HiveHelper.storeInHive(boxName: AppKeys.userBox, key: AppKeys.userId, value: right.id);
        emit(state.copyWith(loginStatus: Status.success, loginResponse: right));
      },
    );
  }
}
