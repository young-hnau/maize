import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealie_mobile/Pages/Home/ShoppingLists/ShoppingList/CreateShoppingItem/create_shopping_item_overlay.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit({required this.appBloc, required ShoppingList shoppingList})
      : _shoppingList = shoppingList,
        super(const ShoppingListState(
          status: ShoppingListStatus.unintialized,
        )) {
    getShoppingList();
  }

  final AppBloc appBloc;
  final ShoppingList _shoppingList;

  Future<void> getShoppingList() async {
    emit(state.copyWith(status: ShoppingListStatus.loading));

    ShoppingList? shoppingList =
        await appBloc.repo.getOneShoppingList(list: _shoppingList);

    if (shoppingList == null) {
      emit(state.copyWith(
        status: ShoppingListStatus.error,
        errorMessage:
            "An unknown error occured while getting the shopping list",
      ));
      return;
    }

    final List<ShoppingListItem>? shoppingListItems = shoppingList.items;
    shoppingListItems
        ?.sort((a, b) => a.note.toLowerCase().compareTo(b.note.toLowerCase()));

    shoppingList = shoppingList.copyWith(items: shoppingListItems);
    emit(state.copyWith(
      status: ShoppingListStatus.loaded,
      shoppingList: shoppingList,
    ));
  }

  void toggleShowChecked() {
    emit(state.copyWith(status: state.status, showChecked: !state.showChecked));
  }

  Future<void> checkItem(ShoppingListItem item) async {
    item = item.copyWith(checked: !item.checked);

    await appBloc.repo.updateOneShoppingListItem(item: item);
    getShoppingList();
  }

  void toggleEditing(ShoppingListItem item) {
    List<ShoppingListItem> shoppingListItems =
        List<ShoppingListItem>.from(state.shoppingList!.items ?? []);
    int i = 0;
    for (i = 0; i < shoppingListItems.length; i++) {
      if (shoppingListItems[i].id == item.id) break;
    }
    shoppingListItems.removeAt(i);
    shoppingListItems = List<ShoppingListItem>.from(shoppingListItems);
    // Store whether the element is being editing in the "extras" part of the object
    item = item.copyWith(extras: {
      'editing': !((item.extras as Map<String, dynamic>)['editing'] ?? false)
    });
    shoppingListItems.insert(i, item);

    ShoppingList shoppingList =
        state.shoppingList!.copyWith(items: shoppingListItems);

    emit(state.copyWith(status: state.status, shoppingList: shoppingList));
  }

  Future<void> updateItem(
    ShoppingListItem item, {
    String? note,
    double? quantity,
  }) async {
    item = item
        .copyWith(quantity: quantity, note: note, extras: {'editing': null});

    await appBloc.repo.updateOneShoppingListItem(item: item);
    getShoppingList();
  }

  Future<void> deleteItem(ShoppingListItem item) async {
    await appBloc.repo.deleteOneShoppingListItem(item: item);
    getShoppingList();
  }

  void removeOverlay() {
    state.overlayEntry!.remove();
    emit(state.copyWith(status: state.status, overlayEntry: null));
  }

  void createOverlay(BuildContext context) {
    OverlayEntry overlayEntry = CreateShoppingItemOverlay(
        shoppingList: state.shoppingList!, shoppingListCubit: this);
    Overlay.of(context).insert(overlayEntry);

    emit(state.copyWith(status: state.status, overlayEntry: overlayEntry));
  }

  Future<void> deleteCheckedItems() async {
    emit(state.copyWith(status: ShoppingListStatus.loading));
    for (ShoppingListItem item in state.shoppingList!.items!) {
      if (item.checked) {
        await appBloc.repo.deleteOneShoppingListItem(item: item);
      }
    }
    getShoppingList();
  }
}
