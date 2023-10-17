part of 'tags_cubit.dart';

enum TagsStatus {
  ready,
  loading,
}

class TagsState extends Equatable {
  const TagsState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final TagsStatus status;
  final Uri? uri;
  final String? errorMessage;

  TagsState copyWith({
    required TagsStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return TagsState(
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
