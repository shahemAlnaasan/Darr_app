part of 'prices_bloc.dart';

class PricesState extends Equatable {
  final String? errorMessage;
  final Status? getPricesStatus;
  final Status? getExchangeSypStatus;
  final Status? getExchangeUsdStatus;
  final Status? getCursStatus;
  final Status? addExchangeStatus;
  final Status? updateExchangeStatus;
  final Status? getUniPricesStatus;
  final GetPricesResponse? getPricesResponse;
  final bool? isRefreshPrices;
  final Status? getUsdPricesStatus;
  final GetPricesResponse? getUsdPricesResponse;
  final GetExchangeResponse? getExchangeSypResponse;
  final GetExchangeResponse? getExchangeUsdResponse;
  final List<GetPricesUniResponse>? getPricesUniResponse;
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
    this.getUniPricesStatus,
    this.getPricesUniResponse,
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
    Status? getUniPricesStatus,
    GetPricesResponse? getPricesResponse,
    bool? isRefreshPrices,
    Status? getUsdPricesStatus,
    GetPricesResponse? getUsdPricesResponse,
    GetExchangeResponse? getExchangeSypResponse,
    GetExchangeResponse? getExchangeUsdResponse,
    List<GetPricesUniResponse>? getPricesUniResponse,
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
      getUniPricesStatus: getUniPricesStatus ?? this.getUniPricesStatus,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      isRefreshPrices: isRefreshPrices ?? this.isRefreshPrices,
      getUsdPricesStatus: getUsdPricesStatus ?? this.getUsdPricesStatus,
      getUsdPricesResponse: getUsdPricesResponse ?? this.getUsdPricesResponse,
      getExchangeSypResponse: getExchangeSypResponse ?? this.getExchangeSypResponse,
      getExchangeUsdResponse: getExchangeUsdResponse ?? this.getExchangeUsdResponse,
      isRefreshUsdPrices: isRefreshUsdPrices ?? this.isRefreshUsdPrices,
      exchangePrices: exchangePrices ?? this.exchangePrices,
      getCursResponse: getCursResponse ?? this.getCursResponse,
      getPricesUniResponse: getPricesUniResponse ?? this.getPricesUniResponse,
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
    getUniPricesStatus,
    getPricesResponse,
    isRefreshPrices,
    getUsdPricesStatus,
    getUsdPricesResponse,
    getExchangeSypResponse,
    getExchangeUsdResponse,
    isRefreshUsdPrices,
    exchangePrices,
    getCursResponse,
    getPricesUniResponse,
  ];
}
