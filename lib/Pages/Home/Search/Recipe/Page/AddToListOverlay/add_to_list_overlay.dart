import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Search/Recipe/Page/AddToListOverlay/add_to_list_cubit.dart';
import 'package:maize/Pages/Home/Search/Recipe/recipe_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

class AddToListOverlay extends OverlayEntry {
  AddToListOverlay({required RecipeCubit recipeCubit})
      : super(
          builder: (context) {
            final TextEditingController nameTFController =
                TextEditingController();
            final TextEditingController quantityTFController =
                TextEditingController();
            final TextEditingController dropDownMenuController =
                TextEditingController();
            return Material(
              color: Colors.black.withOpacity(0.1),
              child: InkWell(
                onTap: recipeCubit.removeOverlay,
                child: BlocProvider(
                  create: (_) => AddToListCubit(
                    appBloc: context.read<AppBloc>(),
                    recipeCubit: recipeCubit,
                  ),
                  child: BlocBuilder<AddToListCubit, AddToListState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case AddToListStatus.loading:
                          return _LoadingScreen();
                        case AddToListStatus.loaded:
                          return _LoadedScreen(
                            createShoppingListCubit:
                                context.read<AddToListCubit>(),
                            shoppingListsCubit: recipeCubit,
                            nameTFController: nameTFController,
                            quantityTFController: quantityTFController,
                            dropDownMenuController: dropDownMenuController,
                          );
                        default:
                          return _ErrorScreen(
                              createShoppingListCubit:
                                  context.read<AddToListCubit>());
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
    required this.createShoppingListCubit,
  });

  final AddToListCubit createShoppingListCubit;

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
              Text(createShoppingListCubit.state.errorMessage.toString()),
              const SizedBox(height: 10),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.replay_outlined))
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 225,
        child: const Card(
          child: Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen({
    required this.createShoppingListCubit,
    required this.shoppingListsCubit,
    required this.nameTFController,
    required this.quantityTFController,
    required this.dropDownMenuController,
  });

  final AddToListCubit createShoppingListCubit;
  final RecipeCubit shoppingListsCubit;
  final TextEditingController nameTFController;
  final TextEditingController quantityTFController;
  final TextEditingController dropDownMenuController;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 225,
      child: Card(
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Add Recipe to Shopping List",
                style: TextStyle(
                  color: MealieColors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              DropdownMenu<ShoppingList>(
                width: MediaQuery.of(context).size.width * 0.7,
                controller: dropDownMenuController,
                onSelected: (value) =>
                    context.read<AddToListCubit>().selectList(value),
                dropdownMenuEntries: List.generate(
                    context.read<AddToListCubit>().state.shoppingLists!.length,
                    (int index) {
                  List<ShoppingList> shoppingLists =
                      context.read<AddToListCubit>().state.shoppingLists!;
                  return DropdownMenuEntry(
                      value: shoppingLists[index],
                      label: shoppingLists[index].name.toString());
                }),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: MealieColors.green,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TextButton(
                    onPressed: context.read<AddToListCubit>().addToList,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
