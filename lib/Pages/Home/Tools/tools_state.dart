part of 'tools_cubit.dart';

enum ToolsStatus {
  ready,
  loading,
}

class ToolsState extends Equatable {
  const ToolsState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final ToolsStatus status;
  final Uri? uri;
  final String? errorMessage;

  ToolsState copyWith({
    required ToolsStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return ToolsState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        errorMessage,
      ];
}
