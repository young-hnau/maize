part of 'timeline_cubit.dart';

enum TimelineStatus {
  ready,
  loading,
}

class TimelineState extends Equatable {
  const TimelineState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final TimelineStatus status;
  final Uri? uri;
  final String? errorMessage;

  TimelineState copyWith({
    required TimelineStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return TimelineState(
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
