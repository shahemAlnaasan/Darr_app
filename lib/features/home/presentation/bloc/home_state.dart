part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String? errorMessage;
  final Status? getAvgPricesStatus;
  final Status? getCursStatus;
  final Status? getPricesStatus;
  final Status? getAdsStatus;
  final Status? getAtmInfoStatus;
  final AvgPricesResponse? avgPricesResponse;
  final GetCursResponse? getCursResponse;
  final GetPricesResponse? getPricesResponse;
  final GetAdsResponse? getAdsResponse;
  final GetAtmsInfoResponse? getAtmsInfoResponse;
  final bool isRefreshPrices;
  final bool isRefreshingAvgPrices;
  const HomeState({
    this.errorMessage,
    this.getAvgPricesStatus,
    this.getPricesStatus,
    this.getAdsStatus,
    this.getAtmInfoStatus,
    this.getAdsResponse,
    this.avgPricesResponse,
    this.isRefreshPrices = false,
    this.isRefreshingAvgPrices = false,
    this.getCursStatus,
    this.getCursResponse,
    this.getPricesResponse,
    this.getAtmsInfoResponse,
  });

  HomeState copyWith({
    String? errorMessage,
    Status? getAvgPricesStatus,
    Status? getCursStatus,
    Status? getPricesStatus,
    Status? getAdsStatus,
    Status? getAtmInfoStatus,
    AvgPricesResponse? avgPricesResponse,
    GetCursResponse? getCursResponse,
    GetPricesResponse? getPricesResponse,
    GetAdsResponse? getAdsResponse,
    GetAtmsInfoResponse? getAtmsInfoResponse,
    bool? isRefreshingAvgPrices,
    bool? isRefreshPrices,
  }) {
    return HomeState(
      errorMessage: errorMessage ?? this.errorMessage,
      getAvgPricesStatus: getAvgPricesStatus ?? this.getAvgPricesStatus,
      getCursStatus: getCursStatus ?? this.getCursStatus,
      getPricesStatus: getPricesStatus ?? this.getPricesStatus,
      getAdsStatus: getAdsStatus ?? this.getAdsStatus,
      getAtmInfoStatus: getAtmInfoStatus ?? this.getAtmInfoStatus,
      avgPricesResponse: avgPricesResponse ?? this.avgPricesResponse,
      getCursResponse: getCursResponse ?? this.getCursResponse,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      getAdsResponse: getAdsResponse ?? this.getAdsResponse,
      getAtmsInfoResponse: getAtmsInfoResponse ?? this.getAtmsInfoResponse,
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
    getAdsStatus,
    getAtmInfoStatus,
    avgPricesResponse,
    isRefreshingAvgPrices,
    getCursResponse,
    getPricesResponse,
    getAdsResponse,
    getAtmsInfoResponse,
    isRefreshPrices,
  ];
}
