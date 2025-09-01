part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetAvgPrices extends HomeEvent {
  final bool isRefreshScreen;

  const GetAvgPrices({this.isRefreshScreen = false});
}

class GetCursEvent extends HomeEvent {}

class GetAdsEvent extends HomeEvent {}

class GetAtmInfoEvent extends HomeEvent {
  final String id;

  const GetAtmInfoEvent({required this.id});
}

class GetPricesEvent extends HomeEvent {
  final bool isRefreshScreen;

  const GetPricesEvent({this.isRefreshScreen = false});
}
