part of 'prices_bloc.dart';

class PricesState extends Equatable {
  final String? errorMessage;
  final Status? getPricesStatus;
  final Status? getExchangeSypStatus;
  final Status? getExchangeUsdStatus;
  final Status? getCursStatus;
  final Status? addExchangeStatus;
  final Status? updateExchangeStatus;
  final GetPricesResponse? getPricesResponse;
  final bool? isRefreshPrices;
  final Status? getUsdPricesStatus;
  final GetPricesResponse? getUsdPricesResponse;
  final GetExchangeResponse? getExchangeSypResponse;
  final GetExchangeResponse? getExchangeUsdResponse;
  final List<Price>? exchangePrices;
  final bool? isRefreshUsdPrices;
  final GetCursResponse? getCursResponse;
  const PricesState({
    this.errorMessage,
    this.addExchangeStatus,
    this.getPricesStatus,
    this.updateExchangeStatus,
    this.getPricesResponse,
    this.isRefreshPrices,
    this.getUsdPricesStatus,
    this.getUsdPricesResponse,
    this.isRefreshUsdPrices,
    this.getExchangeSypStatus,
    this.getExchangeUsdStatus,
    this.getExchangeSypResponse,
    this.getExchangeUsdResponse,
    this.exchangePrices,
    this.getCursStatus,
    this.getCursResponse,
  });

  PricesState copyWith({
    String? errorMessage,
    Status? getPricesStatus,
    Status? getExchangeSypStatus,
    Status? getExchangeUsdStatus,
    Status? addExchangeStatus,
    Status? updateExchangeStatus,
    Status? getCursStatus,
    GetPricesResponse? getPricesResponse,
    bool? isRefreshPrices,
    Status? getUsdPricesStatus,
    GetPricesResponse? getUsdPricesResponse,
    GetExchangeResponse? getExchangeSypResponse,
    GetExchangeResponse? getExchangeUsdResponse,
    List<Price>? exchangePrices,
    bool? isRefreshUsdPrices,
    GetCursResponse? getCursResponse,
  }) {
    return PricesState(
      errorMessage: errorMessage ?? this.errorMessage,
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      getExchangeSypStatus: getExchangeSypStatus ?? this.getExchangeSypStatus,
      getExchangeUsdStatus: getExchangeUsdStatus ?? this.getExchangeUsdStatus,
      addExchangeStatus: addExchangeStatus ?? this.addExchangeStatus,
      updateExchangeStatus: updateExchangeStatus ?? this.updateExchangeStatus,
      getCursStatus: getCursStatus ?? this.getCursStatus,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      isRefreshPrices: isRefreshPrices ?? this.isRefreshPrices,
      getUsdPricesStatus: getUsdPricesStatus ?? this.getUsdPricesStatus,
      getUsdPricesResponse: getUsdPricesResponse ?? this.getUsdPricesResponse,
      getExchangeSypResponse: getExchangeSypResponse ?? this.getExchangeSypResponse,
      getExchangeUsdResponse: getExchangeUsdResponse ?? this.getExchangeUsdResponse,
      isRefreshUsdPrices: isRefreshUsdPrices ?? this.isRefreshUsdPrices,
      exchangePrices: exchangePrices ?? this.exchangePrices,
      getCursResponse: getCursResponse ?? this.getCursResponse,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    getPricesStatus,
    getExchangeSypStatus,
    getExchangeUsdStatus,
    addExchangeStatus,
    updateExchangeStatus,
    getCursStatus,
    getPricesResponse,
    isRefreshPrices,
    getUsdPricesStatus,
    getUsdPricesResponse,
    getExchangeSypResponse,
    getExchangeUsdResponse,
    isRefreshUsdPrices,
    exchangePrices,
    getCursResponse,
  ];
}
