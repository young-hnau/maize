part of "authentication_cubit.dart";

enum AuthenticationStatus {
  ready,
  loading,
  valid,
  invalid,
}

class AuthenticationState extends Equatable {
  const AuthenticationState({
    required this.status,
    this.uri,
    this.errorMessage,
    this.showPassword = false,
    this.rememberMe = false,
  });

  final AuthenticationStatus status;
  final Uri? uri;
  final String? errorMessage;
  final bool showPassword;
  final bool rememberMe;

  AuthenticationState copyWith({
    required AuthenticationStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return AuthenticationState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
      showPassword: showPassword ?? this.showPassword,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props =>
      [status, uri, errorMessage, showPassword, rememberMe];
}
