part of 'categories_cubit.dart';

enum CategoriesStatus {
  ready,
  loading,
}

class CategoriesState extends Equatable {
  const CategoriesState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final CategoriesStatus status;
  final Uri? uri;
  final String? errorMessage;

  CategoriesState copyWith({
    required CategoriesStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return CategoriesState(
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
