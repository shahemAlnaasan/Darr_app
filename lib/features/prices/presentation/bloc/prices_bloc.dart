import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'prices_event.dart';
part 'prices_state.dart';

class PricesBloc extends Bloc<PricesEvent, PricesState> {
  PricesBloc() : super(PricesState());
}
