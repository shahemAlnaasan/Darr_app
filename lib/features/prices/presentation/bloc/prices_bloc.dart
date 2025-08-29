import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_usd_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_prices_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_usd_prices_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'prices_event.dart';
part 'prices_state.dart';

@injectable
class PricesBloc extends Bloc<PricesEvent, PricesState> {
  final GetPricesUsecase getPricesUsecase;
  final GetUsdPricesUsecase getUsdPricesUsecase;
  final GetExchangeSypUsecase getExchangeSypUsecase;
  final GetExchangeUsdUsecase getExchangeUsdUsecase;
  PricesBloc({
    required this.getPricesUsecase,
    required this.getUsdPricesUsecase,
    required this.getExchangeSypUsecase,
    required this.getExchangeUsdUsecase,
  }) : super(PricesState()) {
    on<GetPricesEvent>(_onGetPricesEvent);
    on<GetUsdPricesEvent>(_onGetUsdPricesEvent);
    on<GetExchangeSypEvent>(_onGetExchangeSypEvent);
    on<GetExchangeUsdEvent>(_onGetExchangeUsdEvent);
  }
  Future<void> _onGetPricesEvent(GetPricesEvent event, Emitter<PricesState> emit) async {
    if (state.getPricesResponse != null && !event.isRefreshScreen) {
      emit(state.copyWith(isRefreshPrices: true));
    } else {
      emit(state.copyWith(getPricesStatus: Status.loading));
    }
    final result = await getPricesUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getPricesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getPricesStatus: Status.success, getPricesResponse: right));
      },
    );
  }

  Future<void> _onGetUsdPricesEvent(GetUsdPricesEvent event, Emitter<PricesState> emit) async {
    if (state.getUsdPricesResponse != null && !event.isRefreshScreen) {
      emit(state.copyWith(isRefreshUsdPrices: true));
    } else {
      emit(state.copyWith(getUsdPricesStatus: Status.loading));
    }
    final result = await getUsdPricesUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getUsdPricesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getUsdPricesStatus: Status.success, getUsdPricesResponse: right));
      },
    );
  }

  Future<void> _onGetExchangeSypEvent(GetExchangeSypEvent event, Emitter<PricesState> emit) async {
    emit(state.copyWith(getExchangeSypStatus: Status.loading));
    final int? id = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.userId);

    final result = await getExchangeSypUsecase(params: GetExchangeSypParams(id: id.toString()));

    result.fold(
      (left) {
        emit(state.copyWith(getExchangeSypStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            getExchangeSypStatus: Status.success,
            exchangePrices: [...?state.exchangePrices, ...right.prices],
          ),
        );
      },
    );
  }

  Future<void> _onGetExchangeUsdEvent(GetExchangeUsdEvent event, Emitter<PricesState> emit) async {
    emit(state.copyWith(getUsdPricesStatus: Status.loading));
    final int? id = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.userId);

    final result = await getExchangeUsdUsecase(params: GetExchangeUsdParams(id: id.toString()));

    result.fold(
      (left) {
        emit(state.copyWith(getUsdPricesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(
          state.copyWith(
            getUsdPricesStatus: Status.success,
            exchangePrices: [...?state.exchangePrices, ...right.prices],
          ),
        );
      },
    );
  }
}
