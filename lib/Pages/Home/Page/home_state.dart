part of 'home_cubit.dart';

enum HomeStatus {
  ready,
  loading,
  error,
}

class HomeState extends Equatable {
  const HomeState({
    required this.context,
    required this.status,
    required this.onScreen,
    this.errorMessage,
  });

  final HomeStatus status;
  final String? errorMessage;
  final Widget onScreen;
  final BuildContext context;

  HomeState copyWith({
    required HomeStatus status,
    String? errorMessage,
    Widget? onScreen,
  }) {
    return HomeState(
      context: context,
      status: status,
      errorMessage: errorMessage ?? this.errorMessage,
      onScreen: onScreen ?? this.onScreen,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        onScreen,
      ];
}
