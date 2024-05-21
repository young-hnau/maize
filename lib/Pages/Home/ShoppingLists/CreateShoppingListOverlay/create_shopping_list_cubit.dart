import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/ShoppingLists/shopping_lists_cubit.dart';
import 'package:maize/app/app_bloc.dart';

part 'create_shopping_list_state.dart';

class CreateShoppingListCubit extends Cubit<CreateShoppingListState> {
  CreateShoppingListCubit({
    required this.appBloc,
    required this.shoppingListCubit,
  }) : super(const CreateShoppingListState(
          status: CreateShoppingListStatus.ready,
        ));

  final AppBloc appBloc;
  final RecipeCubit shoppingListCubit;

  Future<void> createList({
    required String name,
  }) async {
    await appBloc.repo.createOneShoppingList(name: name);
    shoppingListCubit.removeOverlay();
    shoppingListCubit.getShoppingLists();
  }

  void resetCard() {
    emit(state.copyWith(
        status: CreateShoppingListStatus.ready, errorMessage: null));
  }
}
