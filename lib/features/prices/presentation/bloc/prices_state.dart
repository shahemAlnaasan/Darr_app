part of 'prices_bloc.dart';

class PricesState extends Equatable {
  final String? errorMessage;
  final Status? getPricesStatus;
  final GetPricesResponse? getPricesResponse;
  final bool? isRefreshPrices;
  final Status? getUsdPricesStatus;
  final GetPricesResponse? getUsdPricesResponse;
  final bool? isRefreshUsdPrices;
  const PricesState({
    this.errorMessage,
    this.getPricesStatus,
    this.getPricesResponse,
    this.isRefreshPrices,
    this.getUsdPricesStatus,
    this.getUsdPricesResponse,
    this.isRefreshUsdPrices,
  });

  PricesState copyWith({
    String? errorMessage,
    Status? getPricesStatus,
    GetPricesResponse? getPricesResponse,
    bool? isRefreshPrices,
    Status? getUsdPricesStatus,
    GetPricesResponse? getUsdPricesResponse,
    bool? isRefreshUsdPrices,
  }) {
    return PricesState(
      errorMessage: errorMessage ?? this.errorMessage,
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      isRefreshPrices: isRefreshPrices ?? this.isRefreshPrices,
      getUsdPricesStatus: getUsdPricesStatus ?? this.getUsdPricesStatus,
      getUsdPricesResponse: getUsdPricesResponse ?? this.getUsdPricesResponse,
      isRefreshUsdPrices: isRefreshUsdPrices ?? this.isRefreshUsdPrices,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    getPricesStatus,
    getPricesResponse,
    isRefreshPrices,
    getUsdPricesStatus,
    getUsdPricesResponse,
    isRefreshUsdPrices,
  ];
}
