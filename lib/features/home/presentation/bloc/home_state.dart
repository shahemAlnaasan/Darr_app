part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String? errorMessage;
  final Status? getAvgPricesStatus;
  final Status? getCursStatus;
  final Status? getPricesStatus;
  final Status? getAdsStatus;
  final Status? getAtmInfoStatus;
  final Status? getCompanyInfoStatus;
  final AvgPricesResponse? avgPricesResponse;
  final GetCursResponse? getCursResponse;
  final GetPricesResponse? getPricesResponse;
  final GetAdsResponse? getAdsResponse;
  final GetAtmsInfoResponse? getAtmsInfoResponse;
  final GetCompanyInfoResponse? getCompanyInfoResponse;
  final bool isRefreshPrices;
  final bool isRefreshingAvgPrices;
  const HomeState({
    this.errorMessage,
    this.getAvgPricesStatus,
    this.getPricesStatus,
    this.getAdsStatus,
    this.getAtmInfoStatus,
    this.getCompanyInfoStatus,
    this.getAdsResponse,
    this.avgPricesResponse,
    this.isRefreshPrices = false,
    this.isRefreshingAvgPrices = false,
    this.getCursStatus,
    this.getCursResponse,
    this.getPricesResponse,
    this.getAtmsInfoResponse,
    this.getCompanyInfoResponse,
  });

  HomeState copyWith({
    String? errorMessage,
    Status? getAvgPricesStatus,
    Status? getCursStatus,
    Status? getPricesStatus,
    Status? getAdsStatus,
    Status? getAtmInfoStatus,
    Status? getCompanyInfoStatus,
    AvgPricesResponse? avgPricesResponse,
    GetCursResponse? getCursResponse,
    GetPricesResponse? getPricesResponse,
    GetAdsResponse? getAdsResponse,
    GetAtmsInfoResponse? getAtmsInfoResponse,
    GetCompanyInfoResponse? getCompanyInfoResponse,
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
      getCompanyInfoStatus: getCompanyInfoStatus ?? this.getCompanyInfoStatus,
      avgPricesResponse: avgPricesResponse ?? this.avgPricesResponse,
      getCursResponse: getCursResponse ?? this.getCursResponse,
      getPricesResponse: getPricesResponse ?? this.getPricesResponse,
      getAdsResponse: getAdsResponse ?? this.getAdsResponse,
      getAtmsInfoResponse: getAtmsInfoResponse ?? this.getAtmsInfoResponse,
      getCompanyInfoResponse: getCompanyInfoResponse ?? this.getCompanyInfoResponse,
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
    getCompanyInfoStatus,
    avgPricesResponse,
    isRefreshingAvgPrices,
    getCursResponse,
    getPricesResponse,
    getAdsResponse,
    getAtmsInfoResponse,
    getCompanyInfoResponse,
    isRefreshPrices,
  ];
}
