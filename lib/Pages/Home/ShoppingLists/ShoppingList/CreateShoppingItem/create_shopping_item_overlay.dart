import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/ShoppingLists/ShoppingList/CreateShoppingItem/create_shopping_item_cubit.dart';
import 'package:maize/Pages/Home/ShoppingLists/ShoppingList/shopping_list_cubit.dart';
import 'package:maize/Pages/Home/ShoppingLists/ShoppingList/shopping_list_page.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

class CreateShoppingItemOverlay extends OverlayEntry {
  CreateShoppingItemOverlay(
      {required ShoppingListCubit shoppingListCubit,
      required ShoppingList shoppingList})
      : super(
          builder: (context) {
            final TextEditingController noteTFController =
                TextEditingController();
            final TextEditingController quantityTFController =
                TextEditingController();
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Material(
                color: Colors.black.withOpacity(0.2),
                child: BlocProvider(
                  create: (_) => CreateShoppingItemCubit(
                    appBloc: context.read<AppBloc>(),
                  ),
                  child: BlocBuilder<CreateShoppingItemCubit,
                      CreateShoppingItemState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case CreateShoppingItemStatus.ready:
                          return _LoadedScreen(
                            createShoppingListCubit:
                                context.read<CreateShoppingItemCubit>(),
                            shoppingList: shoppingList,
                            shoppingListCubit: shoppingListCubit,
                            noteTFController: noteTFController,
                            quantityTFController: quantityTFController,
                          );
                        default:
                          return _ErrorScreen(
                              cubit: context.read<CreateShoppingItemCubit>());
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({
    required this.cubit,
  });

  final CreateShoppingItemCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Error",
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 10),
              Text(cubit.state.errorMessage.toString()),
              const SizedBox(height: 10),
              IconButton(
                  onPressed: () => cubit.resetCard(),
                  icon: const Icon(Icons.replay_outlined))
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen({
    required this.createShoppingListCubit,
    required this.shoppingListCubit,
    required this.shoppingList,
    required this.noteTFController,
    required this.quantityTFController,
  });

  final CreateShoppingItemCubit createShoppingListCubit;
  final ShoppingListCubit shoppingListCubit;
  final ShoppingList shoppingList;
  final TextEditingController noteTFController;
  final TextEditingController quantityTFController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 270,
        child: CurrentlyEditingItemTile(
          title: "Create New Item",
          item: ShoppingListItem.empty,
          shoppingListCubit: ShoppingListCubit(
              appBloc: AppBloc(), shoppingList: ShoppingList.empty),
          noteTFController: noteTFController,
          quantityTFController: quantityTFController,
          onClose: () => shoppingListCubit.removeOverlay(),
          onSave: () => createShoppingListCubit.createItem(
              item: ShoppingListItem(
                quantity: double.parse(quantityTFController.value.text == ''
                    ? '1'
                    : quantityTFController.value.text),
                note: noteTFController.value.text,
                shoppingListId: shoppingList.id,
                checked: false,
              ),
              shoppingListCubit: shoppingListCubit),
        ),
      ),
    );
  }
}
