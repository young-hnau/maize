import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'favorite_recipes_state.dart';

class FavoriteRecipesCubit extends Cubit<FavoriteRecipesState> {
  FavoriteRecipesCubit({required this.appBloc})
      : super(const FavoriteRecipesState(
          status: FavoriteRecipesStatus.ready,
        )) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {
    emit(state.copyWith(
      status: FavoriteRecipesStatus.loaded,
      favoriteRecipes: await appBloc.repo.getFavoriteRecipes(),
    ));
  }
}
