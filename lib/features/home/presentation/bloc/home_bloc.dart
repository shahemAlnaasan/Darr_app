import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/features/home/data/models/get_ads_response.dart';
import 'package:exchange_darr/features/home/data/models/get_atms_info_response.dart';
import 'package:exchange_darr/features/home/data/models/get_company_info_response.dart';
import 'package:exchange_darr/features/home/domain/use_cases/get_ads_usecase.dart';
import 'package:exchange_darr/features/home/domain/use_cases/get_atms_info_usecase.dart';
import 'package:exchange_darr/features/home/domain/use_cases/get_company_info_usecase.dart';
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
  final GetAdsUsecase getAdsUsecase;
  final GetAtmsInfoUsecase getAtmsInfoUsecase;
  final GetPricesUsecase getPricesUsecase;
  final GetCompanyInfoUsecase getCompanyInfoUsecase;
  HomeBloc({
    required this.avgPricesUsecase,
    required this.getCursUsecase,
    required this.getPricesUsecase,
    required this.getAdsUsecase,
    required this.getAtmsInfoUsecase,
    required this.getCompanyInfoUsecase,
  }) : super(HomeState()) {
    on<GetAvgPrices>(_onGetAvgPrice);
    on<GetCompanyInfoEvent>(_onGetCompanyInfoEvent);
    on<GetCursEvent>(_onGetCursEvent);
    on<GetPricesEvent>(_onGetPricesEvent);
    on<GetAdsEvent>(_onGetAdsEvent);
    on<GetAtmInfoEvent>(_onGetAtmInfoEvent);
  }

  Future<void> _onGetCursEvent(GetCursEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getCursStatus: Status.loading));

    final result = await getCursUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getCursStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getCursResponse: right));
      },
    );
  }

  Future<void> _onGetAdsEvent(GetAdsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getAdsStatus: Status.loading));

    final result = await getAdsUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getAdsStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getAdsStatus: Status.success, getAdsResponse: right));
      },
    );
  }

  Future<void> _onGetAtmInfoEvent(GetAtmInfoEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getAtmInfoStatus: Status.loading));

    final result = await getAtmsInfoUsecase(params: GetAtmsInfoParams(id: event.id));

    result.fold(
      (left) {
        emit(state.copyWith(getAtmInfoStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getAtmInfoStatus: Status.success, getAtmsInfoResponse: right));
      },
    );
  }

  Future<void> _onGetCompanyInfoEvent(GetCompanyInfoEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getCompanyInfoStatus: Status.loading));

    final result = await getCompanyInfoUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getCompanyInfoStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getCompanyInfoStatus: Status.success, getCompanyInfoResponse: right));
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
        emit(state.copyWith(getPricesStatus: Status.success, getCursStatus: Status.success, getPricesResponse: right));
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
        emit(
          state.copyWith(getAvgPricesStatus: Status.success, getCursStatus: Status.success, avgPricesResponse: right),
        );
      },
    );
  }
}
