part of "provide_uri_cubit.dart";

enum ProvideURIStatus {
  ready,
  loading,
  valid,
  invalid,
}

class ProvideURIState extends Equatable {
  const ProvideURIState({required this.status, this.uri, this.errorMessage});

  final ProvideURIStatus status;
  final Uri? uri;
  final String? errorMessage;

  ProvideURIState copyWith({
    required ProvideURIStatus status,
    Uri? uri,
    String? errorMessage,
  }) {
    return ProvideURIState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, uri, errorMessage];
}
