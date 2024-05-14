import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/ShoppingLists/CreateShoppingListOverlay/create_shopping_list_cubit.dart';
import 'package:maize/Pages/Home/ShoppingLists/shopping_lists_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';

class CreateShoppingListOverlay extends OverlayEntry {
  CreateShoppingListOverlay({required ShoppingListsCubit shoppingListsCubit})
      : super(
          builder: (context) {
            final TextEditingController nameTFController =
                TextEditingController();
            final TextEditingController quantityTFController =
                TextEditingController();
            return Material(
              color: Colors.black.withOpacity(0.0),
              child: InkWell(
                onTap: shoppingListsCubit.removeOverlay,
                child: BlocProvider(
                  create: (_) => CreateShoppingListCubit(
                    appBloc: context.read<AppBloc>(),
                    shoppingListCubit: shoppingListsCubit,
                  ),
                  child: BlocBuilder<CreateShoppingListCubit,
                      CreateShoppingListState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case CreateShoppingListStatus.ready:
                          return _LoadedScreen(
                            createShoppingListCubit:
                                context.read<CreateShoppingListCubit>(),
                            shoppingListsCubit: shoppingListsCubit,
                            nameTFController: nameTFController,
                            quantityTFController: quantityTFController,
                          );
                        default:
                          return _ErrorScreen(
                              createShoppingListCubit:
                                  context.read<CreateShoppingListCubit>());
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

  final CreateShoppingListCubit createShoppingListCubit;

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
                  onPressed: () => createShoppingListCubit.resetCard(),
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
    required this.shoppingListsCubit,
    required this.nameTFController,
    required this.quantityTFController,
  });

  final CreateShoppingListCubit createShoppingListCubit;
  final ShoppingListsCubit shoppingListsCubit;
  final TextEditingController nameTFController;
  final TextEditingController quantityTFController;

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
                "Create Shopping List",
                style: TextStyle(
                  color: MealieColors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              TextField(
                controller: nameTFController,
                decoration: const InputDecoration(
                  label: Text("New List"),
                ),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () => createShoppingListCubit.createList(
                        name: nameTFController.text),
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
