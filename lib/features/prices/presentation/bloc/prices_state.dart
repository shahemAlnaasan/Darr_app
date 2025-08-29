part of 'prices_bloc.dart';

class PricesState extends Equatable {
  final String? errorMessage;
  final Status? getPricesStatus;
  final Status? getExchangeSypStatus;
  final Status? getExchangeUsdStatus;
  final GetPricesResponse? getPricesResponse;
  final bool? isRefreshPrices;
  final Status? getUsdPricesStatus;
  final GetPricesResponse? getUsdPricesResponse;
  final GetExchangeResponse? getExchangeResponse;
  final List<Price>? exchangePrices;
  final bool? isRefreshUsdPrices;
  const PricesState({
    this.errorMessage,
    this.getPricesStatus,
    this.getPricesResponse,
    this.isRefreshPrices,
    this.getUsdPricesStatus,
    this.getUsdPricesResponse,
    this.isRefreshUsdPrices,
    this.getExchangeSypStatus,
    this.getExchangeUsdStatus,
    this.getExchangeResponse,
    this.exchangePrices,
  });

  PricesState copyWith({
    String? errorMessage,
    Status? getPricesStatus,
    Status? getExchangeSypStatus,
    Status? getExchangeUsdStatus,
    GetPricesResponse? getPricesResponse,
    bool? isRefreshPrices,
    Status? getUsdPricesStatus,
    GetPricesResponse? getUsdPricesResponse,
    GetExchangeResponse? getExchangeResponse,
    List<Price>? exchangePrices,
    bool? isRefreshUsdPrices,
  }) {
    return PricesState(
      errorMessage: errorMessage ?? this.errorMessage,
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      getExchangeSypStatus: getExchangeSypStatus ?? this.getExchangeSypStatus,
      getExchangeUsdStatus: getExchangeUsdStatus ?? this.getExchangeUsdStatus,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      isRefreshPrices: isRefreshPrices ?? this.isRefreshPrices,
      getUsdPricesStatus: getUsdPricesStatus ?? this.getUsdPricesStatus,
      getUsdPricesResponse: getUsdPricesResponse ?? this.getUsdPricesResponse,
      getExchangeResponse: getExchangeResponse ?? this.getExchangeResponse,
      isRefreshUsdPrices: isRefreshUsdPrices ?? this.isRefreshUsdPrices,
      exchangePrices: exchangePrices ?? this.exchangePrices,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    getPricesStatus,
    getExchangeSypStatus,
    getExchangeUsdStatus,
    getPricesResponse,
    isRefreshPrices,
    getUsdPricesStatus,
    getUsdPricesResponse,
    getExchangeResponse,
    isRefreshUsdPrices,
    exchangePrices,
  ];
}
