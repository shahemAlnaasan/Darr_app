part of 'prices_bloc.dart';

class PricesState extends Equatable {
  final String? errorMessage;
  const PricesState({this.errorMessage});

    PricesState copyWith({String? errorMessage}) {
    return PricesState(errorMessage: errorMessage ?? this.errorMessage);
  }


  @override
  List<Object?> get props => [errorMessage];
}
