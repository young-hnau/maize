import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Search/Recipe/recipe_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'add_to_list_state.dart';

class AddToListCubit extends Cubit<AddToListState> {
  AddToListCubit({
    required this.appBloc,
    required this.recipeCubit,
  }) : super(const AddToListState(
          status: AddToListStatus.loading,
        )) {
    _initialize();
  }

  final AppBloc appBloc;
  final RecipeCubit recipeCubit;

  Future<void> _initialize() async {
    emit(state.copyWith(
      status: AddToListStatus.loaded,
      shoppingLists: await appBloc.repo.getAllShoppingLists(),
    ));
  }

  void selectList(ShoppingList? shoppingList) {
    emit(state.copyWith(selectedList: shoppingList));
  }

  Future<void> addToList() async {
    if (recipeCubit.state.recipe == null || state.selectedList == null) return;
    emit(state.copyWith(status: AddToListStatus.loading));
    await appBloc.repo.addRecipeIngredientsToShoppingList(
        recipe: recipeCubit.state.recipe!, shoppingList: state.selectedList!);
    recipeCubit.removeOverlay();
  }
}
