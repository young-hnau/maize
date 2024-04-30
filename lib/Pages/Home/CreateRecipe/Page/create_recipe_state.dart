part of 'create_recipe_cubit.dart';

enum CreateRecipeStatus {
  ready,
  loading,
  error,
}

class CreateRecipeState extends Equatable {
  const CreateRecipeState({
    required this.status,
    required this.onScreen,
    this.errorMessage,
  });

  final CreateRecipeStatus status;
  final Widget onScreen;
  final String? errorMessage;

  CreateRecipeState copyWith({
    CreateRecipeStatus? status,
    Widget? onScreen,
    String? errorMessage,
  }) {
    return CreateRecipeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      onScreen: onScreen ?? this.onScreen,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        onScreen,
      ];
}
