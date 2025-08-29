import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
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
  PricesBloc({required this.getPricesUsecase, required this.getUsdPricesUsecase}) : super(PricesState()) {
    on<GetPricesEvent>(_onGetPricesEvent);
    on<GetUsdPricesEvent>(_onGetUsdPricesEvent);
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
}
