import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/features/prices/data/models/avg_prices_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/avg_prices_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_curs_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_prices_usecase.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AvgPricesUsecase avgPricesUsecase;
  final GetCursUsecase getCursUsecase;
  final GetPricesUsecase getPricesUsecase;
  HomeBloc({required this.avgPricesUsecase, required this.getCursUsecase, required this.getPricesUsecase})
    : super(HomeState()) {
    on<GetAvgPrices>(_onGetAvgPrice);
    on<GetCursEvent>(_onGetCursEvent);
    on<GetPricesEvent>(_onGetPricesEvent);
  }

  Future<void> _onGetCursEvent(GetCursEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getCursStatus: Status.loading));

    final result = await getCursUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getCursStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getCursStatus: Status.success, getCursResponse: right));
      },
    );
  }

  Future<void> _onGetPricesEvent(GetPricesEvent event, Emitter<HomeState> emit) async {
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

  Future<void> _onGetAvgPrice(GetAvgPrices event, Emitter<HomeState> emit) async {
    if (state.getAvgPricesStatus != null && !event.isRefreshScreen) {
      emit(state.copyWith(isRefreshingAvgPrices: true));
    } else {
      emit(state.copyWith(getAvgPricesStatus: Status.loading));
    }
    final result = await avgPricesUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getAvgPricesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getAvgPricesStatus: Status.success, avgPricesResponse: right));
      },
    );
  }
}
