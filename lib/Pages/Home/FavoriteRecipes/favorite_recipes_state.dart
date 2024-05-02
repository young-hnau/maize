part of 'favorite_recipes_cubit.dart';

enum FavoriteRecipesStatus {
  ready,
  loading,
  loaded,
  error,
}

class FavoriteRecipesState extends Equatable {
  const FavoriteRecipesState({
    required this.status,
    this.favoriteRecipes,
    this.errorMessage,
  });

  final FavoriteRecipesStatus status;
  final String? errorMessage;
  final List<Recipe?>? favoriteRecipes;

  FavoriteRecipesState copyWith(
      {required FavoriteRecipesStatus status,
      String? errorMessage,
      List<Recipe?>? favoriteRecipes}) {
    return FavoriteRecipesState(
      status: status,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteRecipes: favoriteRecipes ?? this.favoriteRecipes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        favoriteRecipes,
      ];
}
