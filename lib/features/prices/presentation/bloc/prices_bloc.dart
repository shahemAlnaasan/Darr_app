import 'package:exchange_darr/common/consts/app_keys.dart';
import 'package:exchange_darr/common/state_managment/bloc_state.dart';
import 'package:exchange_darr/core/datasources/hive_helper.dart';
import 'package:exchange_darr/features/prices/data/models/get_curs_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_exchage_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_response.dart';
import 'package:exchange_darr/features/prices/data/models/get_prices_uni_response.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/add_exchange_usd_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_curs_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_exchange_usd_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_prices_uni_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_prices_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/get_usd_prices_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/update_exchange_syp_usecase.dart';
import 'package:exchange_darr/features/prices/domain/use_cases/update_exchange_usd_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'prices_event.dart';
part 'prices_state.dart';

@injectable
class PricesBloc extends Bloc<PricesEvent, PricesState> {
  final GetPricesUsecase getPricesUsecase;
  final GetUsdPricesUsecase getUsdPricesUsecase;
  final GetPricesUniUsecase getPricesUniUsecase;
  final GetExchangeSypUsecase getExchangeSypUsecase;
  final GetExchangeUsdUsecase getExchangeUsdUsecase;
  final GetCursUsecase getCursUsecase;
  final AddExchangeSypUsecase addExchangeSypUsecase;
  final AddExchangeUsdUsecase addExchangeUsdUsecase;
  final UpdateExchangeSypUsecase updateExchangeSypUsecase;
  final UpdateExchangeUsdUsecase updateExchangeUsdUsecase;
  PricesBloc({
    required this.getPricesUsecase,
    required this.getUsdPricesUsecase,
    required this.getExchangeSypUsecase,
    required this.getExchangeUsdUsecase,
    required this.getCursUsecase,
    required this.addExchangeSypUsecase,
    required this.addExchangeUsdUsecase,
    required this.updateExchangeSypUsecase,
    required this.updateExchangeUsdUsecase,
    required this.getPricesUniUsecase,
  }) : super(PricesState()) {
    on<GetPricesEvent>(_onGetPricesEvent);
    on<GetUsdPricesEvent>(_onGetUsdPricesEvent);
    on<GetExchangeSypEvent>(_onGetExchangeSypEvent);
    on<GetExchangeUsdEvent>(_onGetExchangeUsdEvent);
    on<GetCursEvent>(_onGetCursEvent);
    on<AddExchangeEvent>(_onAddExchangeEvent);
    on<UpdateExchangeEvent>(_onUpdateExchangeEvent);
    on<GetUniPricesEvent>(_onGetUniPricesEvent);
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
        emit(
          state.copyWith(
            getUsdPricesStatus: Status.success,
            getCursStatus: Status.success,
            getUsdPricesResponse: right,
          ),
        );
      },
    );
  }

  Future<void> _onGetUniPricesEvent(GetUniPricesEvent event, Emitter<PricesState> emit) async {
    if (state.getUniPricesStatus != null && !event.isRefreshScreen) {
      emit(state.copyWith(isRefreshUsdPrices: true));
    } else {
      emit(state.copyWith(getUniPricesStatus: Status.loading));
    }
    final result = await getPricesUniUsecase();

    result.fold(
      (left) {
        emit(state.copyWith(getUniPricesStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(getUniPricesStatus: Status.success, getPricesUniResponse: right));
      },
    );
  }

  Future<void> _onGetCursEvent(GetCursEvent event, Emitter<PricesState> emit) async {
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

  Future<void> _onGetExchangeSypEvent(GetExchangeSypEvent event, Emitter<PricesState> emit) async {
    emit(state.copyWith(getExchangeSypStatus: Status.loading));
    final int? id = await HiveHelper.getFromHive(boxName: AppKeys.userBox, key: AppKeys.userId);

    final result = await getExchangeSypUsecase(params: GetExchangeSypParams(id: id.toString()));

    result.fold(
      (left) {
        emit(state.copyWith(getExchangeSypStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        add(GetExchangeUsdEvent());
        emit(
          state.copyWith(
            getExchangeSypStatus: Status.success,
            getExchangeSypResponse: right,
            getCursStatus: Status.success,
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
            getCursStatus: Status.success,
            exchangePrices: [...state.getExchangeSypResponse!.prices, ...right.prices],
          ),
        );
      },
    );
  }

  Future<void> _onAddExchangeEvent(AddExchangeEvent event, Emitter<PricesState> emit) async {
    emit(state.copyWith(addExchangeStatus: Status.loading));
    final dynamic result;
    if (event.isSyp) {
      result = await addExchangeSypUsecase(params: event.params);
    } else {
      result = await addExchangeUsdUsecase(params: event.params);
    }

    result.fold(
      (left) {
        emit(state.copyWith(addExchangeStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(addExchangeStatus: Status.success));
      },
    );
  }

  Future<void> _onUpdateExchangeEvent(UpdateExchangeEvent event, Emitter<PricesState> emit) async {
    emit(state.copyWith(updateExchangeStatus: Status.loading));
    final dynamic result;
    if (event.isSyp) {
      result = await updateExchangeSypUsecase(params: event.params);
    } else {
      result = await updateExchangeUsdUsecase(params: event.params);
    }

    result.fold(
      (left) {
        emit(state.copyWith(updateExchangeStatus: Status.failure, errorMessage: left.message));
      },
      (right) {
        emit(state.copyWith(updateExchangeStatus: Status.success));
      },
    );
  }
}
