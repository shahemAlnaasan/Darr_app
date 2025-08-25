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
