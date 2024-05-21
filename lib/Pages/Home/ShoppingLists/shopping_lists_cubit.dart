import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/ShoppingLists/CreateShoppingListOverlay/create_shopping_list_overlay.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'shopping_lists_state.dart';

class RecipeCubit extends Cubit<ShoppingListsState> {
  RecipeCubit({required this.appBloc})
      : super(const ShoppingListsState(
          status: ShoppingListsStatus.unintialized,
        )) {
    getShoppingLists();
  }

  final AppBloc appBloc;

  Future<void> getShoppingLists() async {
    emit(state.copyWith(status: ShoppingListsStatus.loading));

    List<ShoppingList>? shoppingLists =
        await appBloc.repo.getAllShoppingLists();

    emit(state.copyWith(
      status: ShoppingListsStatus.loaded,
      shoppingLists: shoppingLists,
    ));
  }

  void removeOverlay() {
    state.overlayEntry!.remove();
    emit(state.copyWith(status: state.status, overlayEntry: null));
  }

  void createOverlay(BuildContext context) {
    OverlayEntry overlayEntry =
        CreateShoppingListOverlay(shoppingListsCubit: this);
    Overlay.of(context).insert(overlayEntry);

    emit(state.copyWith(status: state.status, overlayEntry: overlayEntry));
  }

  Future<void> deleteShoppingList(String id) async {
    emit(state.copyWith(status: ShoppingListsStatus.loading));
    await appBloc.repo.deleteOneShoppingList(id: id);
    getShoppingLists();
  }
}
