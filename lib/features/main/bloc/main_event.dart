part of 'main_bloc.dart';

class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class GetThemeEvent extends MainEvent {}

class SetThemeEvent extends MainEvent {
  const SetThemeEvent();
}
