import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/Pages/Home/Search/Recipe/Page/recipe_page.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'import_url_state.dart';

class ImportURLCubit extends Cubit<ImportURLState> {
  ImportURLCubit({
    required this.appBloc,
    required this.homeCubit,
  }) : super(const ImportURLState(
          status: ImportURLStatus.ready,
          includeTags: false,
          urlIsValid: false,
        )) {
    _initialize();
  }

  final AppBloc appBloc;
  final HomeCubit homeCubit;

  Future<void> _initialize() async {}

  void toggleImportOriginalKeywordAsTags(bool? value) {
    emit(state.copyWith(includeTags: value ?? false));
  }

  void updateURL(String? url) {
    emit(state.copyWith(url: url));
  }

  Future<void> create() async {
    emit(state.copyWith(status: ImportURLStatus.loading));
    final String? recipeSlug = await appBloc.repo
        .parseRecipeURL(state.url.toString(), state.includeTags);
    if (recipeSlug == null) {
      emit(state.copyWith(
          status: ImportURLStatus.error,
          errorMessage: "Error importing the recipe URL"));
      return;
    }
    final Recipe? recipe = await appBloc.repo.getRecipe(slug: recipeSlug);
    if (recipe == null) {
      emit(state.copyWith(
          status: ImportURLStatus.error,
          errorMessage: "Error importing the recipe URL"));
      return;
    }
    emit(state.copyWith(status: ImportURLStatus.ready));
    homeCubit.setScreen(RecipePage(recipe: recipe));
  }
}
