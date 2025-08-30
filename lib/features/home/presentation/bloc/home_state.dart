part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String? errorMessage;
  final Status? getAvgPricesStatus;
  final Status? getCursStatus;
  final Status? getPricesStatus;
  final AvgPricesResponse? avgPricesResponse;
  final GetCursResponse? getCursResponse;
  final GetPricesResponse? getPricesResponse;
  final bool isRefreshPrices;
  final bool isRefreshingAvgPrices;
  const HomeState({
    this.errorMessage,
    this.getAvgPricesStatus,
    this.getPricesStatus,
    this.avgPricesResponse,
    this.isRefreshPrices = false,
    this.isRefreshingAvgPrices = false,
    this.getCursStatus,
    this.getCursResponse,
    this.getPricesResponse,
  });

  HomeState copyWith({
    String? errorMessage,
    Status? getAvgPricesStatus,
    Status? getCursStatus,
    Status? getPricesStatus,
    AvgPricesResponse? avgPricesResponse,
    GetCursResponse? getCursResponse,
    GetPricesResponse? getPricesResponse,
    bool? isRefreshingAvgPrices,
    bool? isRefreshPrices,
  }) {
    return HomeState(
      errorMessage: errorMessage ?? this.errorMessage,
      getAvgPricesStatus: getAvgPricesStatus ?? this.getAvgPricesStatus,
      getCursStatus: getCursStatus ?? this.getCursStatus,
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      avgPricesResponse: avgPricesResponse ?? this.avgPricesResponse,
      getCursResponse: getCursResponse ?? this.getCursResponse,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      isRefreshPrices: isRefreshPrices ?? this.isRefreshPrices,
      isRefreshingAvgPrices: isRefreshingAvgPrices ?? this.isRefreshingAvgPrices,
    );
  }

  @override
  List<Object?> get props => [
    errorMessage,
    getAvgPricesStatus,
    getCursStatus,
    getPricesStatus,
    avgPricesResponse,
    isRefreshingAvgPrices,
    getCursResponse,
    getPricesResponse,
    isRefreshPrices,
  ];
}
