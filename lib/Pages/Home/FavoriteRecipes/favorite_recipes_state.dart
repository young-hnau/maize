part of 'favorite_recipes_cubit.dart';

enum FavoriteRecipesStatus {
  ready,
  loading,
}

class FavoriteRecipesState extends Equatable {
  const FavoriteRecipesState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final FavoriteRecipesStatus status;
  final Uri? uri;
  final String? errorMessage;

  FavoriteRecipesState copyWith({
    required FavoriteRecipesStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return FavoriteRecipesState(
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
