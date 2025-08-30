part of 'prices_bloc.dart';

sealed class PricesEvent extends Equatable {
  const PricesEvent();
  @override
  List<Object?> get props => [];
}

class GetPricesEvent extends PricesEvent {
  final bool isRefreshScreen;

  const GetPricesEvent({this.isRefreshScreen = false});
}

class GetUsdPricesEvent extends PricesEvent {
  final bool isRefreshScreen;

  const GetUsdPricesEvent({this.isRefreshScreen = false});
}

class GetExchangeSypEvent extends PricesEvent {}

class GetExchangeUsdEvent extends PricesEvent {}

class GetCursEvent extends PricesEvent {}

class AddExchangeEvent extends PricesEvent {
  final bool isSyp;
  final AddExchangeParams params;

  const AddExchangeEvent({this.isSyp = true, required this.params});
}

class UpdateExchangeEvent extends PricesEvent {
  final bool isSyp;
  final UpdateExchangeParams params;

  const UpdateExchangeEvent({this.isSyp = true, required this.params});
}
