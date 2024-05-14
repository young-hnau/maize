import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'recipe_card_state.dart';

class RecipeCardCubit extends Cubit<RecipeCardState> {
  RecipeCardCubit({
    required this.appBloc,
    bool? isFavorite,
  }) : super(RecipeCardState(
          status: RecipeCardStatus.ready,
          isFavorite: isFavorite,
        )) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {}

  Future<void> toggleFavorite(Recipe recipe) async {
    if (state.isFavorite == true) {
      appBloc.repo.removeFavoriteRecipe(recipe);
      emit(state.copyWith(isFavorite: false));
    } else {
      appBloc.repo.addFavoriteRecipe(recipe);
      emit(state.copyWith(isFavorite: true));
    }
  }
}
