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

    ShoppingList? shoppingList = await appBloc.state.mealieRepository
        .getOneShoppingList(
            token: appBloc.state.user.refreshToken, list: _shoppingList);

    if (shoppingList == null) {
      emit(state.copyWith(
        status: ShoppingListStatus.error,
        errorMessage:
            "An unknown error occured while getting the shopping list",
      ));
      return;
    }

    final List<ShoppingListItem>? shoppingListItems = shoppingList.items;
    shoppingListItems?.sort((a, b) {
      if (a.checked && b.checked) {
        return 0;
      } else if (!a.checked && !b.checked) {
        return 0;
      } else if (a.checked && !b.checked) {
        return 1;
      } else if (!a.checked && b.checked) {
        return -1;
      }
      return 0;
    });

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

    await appBloc.state.mealieRepository.updateOneShoppingListItem(
        token: appBloc.state.user.refreshToken, item: item);
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
    item = item.copyWith(quantity: quantity, note: note);

    await appBloc.state.mealieRepository.updateOneShoppingListItem(
        token: appBloc.state.user.refreshToken, item: item);
    getShoppingList();
  }

  Future<void> deleteItem(ShoppingListItem item) async {
    await appBloc.state.mealieRepository.deleteOneShoppingListItem(
        token: appBloc.state.user.refreshToken, item: item);
    getShoppingList();
  }

  void removeOverlay() {
    state.overlayEntry!.remove();
    emit(state.copyWith(status: state.status, overlayEntry: null));
    getShoppingList();
  }

  void createOverlay(BuildContext context) {
    OverlayEntry overlayEntry = CreateShoppingItemOverlay(
        shoppingList: state.shoppingList!, shoppingListCubit: this);
    Overlay.of(context).insert(overlayEntry);

    emit(state.copyWith(status: state.status, overlayEntry: overlayEntry));
  }
}

// extension on ShoppingListItem {
//   static final _editing = Expando<bool>();

//   bool get editing => _editing[this] ?? false;
//   set editing(bool value) => _editing[this] = value;
// }
