part of 'recipe_card_cubit.dart';

enum RecipeCardStatus {
  ready,
  loading,
  loaded,
  error,
}

class RecipeCardState extends Equatable {
  const RecipeCardState({
    required this.status,
    this.errorMessage,
    this.isFavorite = false,
  });

  final RecipeCardStatus status;
  final String? errorMessage;
  final bool? isFavorite;

  RecipeCardState copyWith({
    RecipeCardStatus? status,
    String? errorMessage,
    bool? isFavorite,
  }) {
    return RecipeCardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        isFavorite,
      ];
}
