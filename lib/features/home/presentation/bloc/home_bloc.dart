import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/features/prices/data/models/avg_prices_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/avg_prices_usecase.dart';
import 'package:injectable/injectable.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AvgPricesUsecase avgPricesUsecase;
  HomeBloc({required this.avgPricesUsecase}) : super(HomeState()) {
    on<GetAvgPrices>(_onGetAvgPrice);
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
