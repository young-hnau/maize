import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/CreateRecipe/ImportURL/import_url_widget.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/app/app_bloc.dart';

part 'create_recipe_state.dart';

class CreateRecipeCubit extends Cubit<CreateRecipeState> {
  CreateRecipeCubit({required this.appBloc, required this.homeCubit})
      : super(
          const CreateRecipeState(
            status: CreateRecipeStatus.ready,
            onScreen: ImportURLWidget(),
          ),
        ) {
    _initialize();
  }

  final AppBloc appBloc;
  final HomeCubit homeCubit;

  Future<void> _initialize() async {}

  void setWidget(Widget screen) {
    emit(state.copyWith(onScreen: screen));
  }
}
