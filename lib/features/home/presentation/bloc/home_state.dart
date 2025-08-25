part of 'home_bloc.dart';

class HomeState extends Equatable {
  final String? errorMessage;
  final Status? getAvgPricesStatus;
  final AvgPricesResponse? avgPricesResponse;
  final bool isRefreshingAvgPrices;
  const HomeState({
    this.errorMessage,
    this.getAvgPricesStatus,
    this.avgPricesResponse,
    this.isRefreshingAvgPrices = false,
  });

  HomeState copyWith({
    String? errorMessage,
    Status? getAvgPricesStatus,
    AvgPricesResponse? avgPricesResponse,
    bool? isRefreshingAvgPrices,
  }) {
    return HomeState(
      errorMessage: errorMessage ?? this.errorMessage,
      getAvgPricesStatus: getAvgPricesStatus ?? this.getAvgPricesStatus,
      avgPricesResponse: avgPricesResponse ?? this.avgPricesResponse,
      isRefreshingAvgPrices: isRefreshingAvgPrices ?? this.isRefreshingAvgPrices,
    );
  }

  @override
  List<Object?> get props => [errorMessage, getAvgPricesStatus, avgPricesResponse, isRefreshingAvgPrices];
}
