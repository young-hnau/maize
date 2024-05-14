import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/Pages/Home/Search/Recipe/Page/recipe_page.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'manual_state.dart';

class ManualCubit extends Cubit<ManualState> {
  ManualCubit({
    required this.appBloc,
    required this.homeCubit,
  }) : super(ManualState(status: ManualStatus.ready)) {
    _initialize();
  }

  final AppBloc appBloc;
  final HomeCubit homeCubit;

  Future<void> _initialize() async {}

  Future<void> create() async {
    final String? slug = await appBloc.repo
        .createRecipe(state.textEditingController.text.toString());
    if (slug == null) {
      emit(
        state.copyWith(
            status: ManualStatus.error,
            errorMessage: "There was an error creating the recipe."),
      );
      return;
    }
    final Recipe? recipe = await appBloc.repo.getRecipe(slug: slug);
    if (recipe == null) {
      emit(
        state.copyWith(
            status: ManualStatus.error,
            errorMessage: "There was an error creating the recipe."),
      );
      return;
    }

    homeCubit.setScreen(RecipePage(recipe: recipe, isEditing: true));
  }
}
