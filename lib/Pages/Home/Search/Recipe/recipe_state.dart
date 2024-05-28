part of 'recipe_cubit.dart';

enum RecipeStatus {
  ready,
  loading,
  loaded,
  editing,
  error,
}

class RecipeState extends Equatable {
  const RecipeState({
    required this.status,
    this.errorMessage,
    this.recipe,
    this.userRating,
    this.overlayEntry,
    Recipe? editingRecipe,
    List<String>? checkedIngredients,
    List<String>? checkedInstructions,
  })  : _editingRecipe = editingRecipe,
        _checkedIngredients = checkedIngredients,
        _checkedInstructions = checkedInstructions;

  final RecipeStatus status;
  final String? errorMessage;
  final Recipe? recipe;
  final Rating? userRating;
  final Recipe? _editingRecipe;
  final List<String>? _checkedIngredients;
  final List<String>? _checkedInstructions;
  final OverlayEntry? overlayEntry;

  List<String>? get checkedIngredients => _checkedIngredients != null
      ? List<String>.from(_checkedIngredients)
      : null;

  List<String>? get checkedInstructions => _checkedInstructions != null
      ? List<String>.from(_checkedInstructions)
      : null;

  Recipe? get editingRecipe => _editingRecipe ?? Recipe.from(recipe);

  RecipeState copyWith({
    RecipeStatus? status,
    String? errorMessage,
    Recipe? recipe,
    Recipe? editingRecipe,
    List<String>? checkedIngredients,
    List<String>? checkedInstructions,
    Rating? userRating,
    OverlayEntry? overlayEntry,
  }) {
    return RecipeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      recipe: recipe ?? this.recipe,
      editingRecipe: editingRecipe ?? this.editingRecipe,
      checkedIngredients: checkedIngredients ?? this.checkedIngredients,
      checkedInstructions: checkedInstructions ?? this.checkedInstructions,
      userRating: userRating ?? this.userRating,
      overlayEntry: overlayEntry ?? this.overlayEntry,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        recipe,
        editingRecipe,
        editingRecipe == null || editingRecipe?.recipeIngredient == null
            ? null
            : List<Ingredient>.from(editingRecipe!.recipeIngredient!),
        checkedIngredients,
        checkedInstructions,
        userRating,
        overlayEntry,
      ];
}
