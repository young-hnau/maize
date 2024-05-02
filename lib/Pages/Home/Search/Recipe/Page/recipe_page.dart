import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mealie_mobile/Pages/Home/Search/Recipe/recipe_cubit.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_mobile/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'editing_screen.dart';
part 'loaded_screen.dart';
part 'loading_screen.dart';
part 'rounded_icon_buttons.dart';
part 'header.dart';
part 'error_screen.dart';
part 'star_rating.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.recipe, this.isEditing});
  final Recipe recipe;
  final bool? isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => RecipeCubit(
          appBloc: context.read<AppBloc>(),
          recipe: recipe,
          isEditing: isEditing,
        ),
        child: BlocBuilder<RecipeCubit, RecipeState>(
          buildWhen: (previous, current) {
            if (previous.recipe != current.recipe) {
              return true;
            }
            if (previous.editingRecipe?.name != current.editingRecipe?.name) {
              return false;
            }
            if (previous.editingRecipe?.recipeYield !=
                current.editingRecipe?.recipeYield) {
              return false;
            }
            if (previous.editingRecipe?.totalTime !=
                current.editingRecipe?.totalTime) {
              return false;
            }
            if (previous.editingRecipe?.prepTime !=
                current.editingRecipe?.prepTime) {
              return false;
            }
            // NOTE: Unsure why, but the API seems to be using prepTime when the UI referes to "Cook Time"
            if (previous.editingRecipe?.performTime !=
                current.editingRecipe?.performTime) {
              return false;
            }
            if (previous.editingRecipe?.description !=
                current.editingRecipe?.description) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            switch (state.status) {
              case RecipeStatus.loading:
              case RecipeStatus.ready:
                return const _LoadingScreen();
              case RecipeStatus.loaded:
                return _LoadedScreen(
                  recipeCubit: context.read<RecipeCubit>(),
                  appBloc: context.read<AppBloc>(),
                  recipe: state.recipe!,
                );
              case RecipeStatus.editing:
                return _EditingScreen(
                  appBloc: context.read<AppBloc>(),
                  recipe: state.editingRecipe!,
                );
              case RecipeStatus.error:
                return _ErrorScreen(state: state);
            }
          },
        ),
      );
    });
  }
}
