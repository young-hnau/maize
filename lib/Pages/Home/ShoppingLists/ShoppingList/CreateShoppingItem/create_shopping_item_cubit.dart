import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/ShoppingLists/ShoppingList/shopping_list_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'create_shopping_item_state.dart';

class CreateShoppingItemCubit extends Cubit<CreateShoppingItemState> {
  CreateShoppingItemCubit({
    required this.appBloc,
  }) : super(const CreateShoppingItemState(
          status: CreateShoppingItemStatus.ready,
        ));

  final AppBloc appBloc;

  Future<void> createItem(
      {required ShoppingListItem item,
      required ShoppingListCubit shoppingListCubit}) async {
    await appBloc.repo.createOneShoppingListItem(item: item);
    shoppingListCubit.removeOverlay();
    shoppingListCubit.getShoppingList();
  }

  void resetCard() {
    emit(state.copyWith(
        status: CreateShoppingItemStatus.ready, errorMessage: null));
  }
}
