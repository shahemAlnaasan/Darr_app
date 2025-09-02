part of 'main_bloc.dart';

enum MainStatus { initial, loading, success, failure }

class MainState extends Equatable {
  final MainStatus? status;
  final String? errorMessage;
  final ThemeData? theme;
  const MainState({this.status, this.errorMessage, this.theme});

  MainState copyWith({MainStatus? status, String? errorMessage, ThemeData? theme}) {
    return MainState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, theme];
}
