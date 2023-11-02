import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'shopping_lists_state.dart';

class ShoppingListsCubit extends Cubit<ShoppingListsState> {
  ShoppingListsCubit({required this.appBloc})
      : super(const ShoppingListsState(
          status: ShoppingListsStatus.unintialized,
        )) {
    _getShoppingLists();
  }

  final AppBloc appBloc;

  Future<void> _getShoppingLists() async {
    emit(state.copyWith(status: ShoppingListsStatus.loading));

    List<ShoppingList>? shoppingLists = await appBloc.repo
        .getAllShoppingLists(token: appBloc.state.user.refreshToken);

    emit(state.copyWith(
      status: ShoppingListsStatus.loaded,
      shoppingLists: shoppingLists,
    ));
  }
}
