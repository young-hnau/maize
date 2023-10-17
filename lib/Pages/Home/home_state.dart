part of 'home_cubit.dart';

enum HomeStatus {
  ready,
  loading,
  error,
}

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.onScreen,
    this.uri,
    this.errorMessage,
  });

  final HomeStatus status;
  final Uri? uri;
  final String? errorMessage;
  final Widget onScreen;

  HomeState copyWith({
    required HomeStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
    Widget? onScreen,
  }) {
    return HomeState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
      onScreen: onScreen ?? this.onScreen,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        errorMessage,
        onScreen,
      ];
}
