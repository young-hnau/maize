import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maize/Pages/Home/ShoppingLists/ShoppingList/shopping_list_page.dart';
import 'package:maize/Pages/Home/ShoppingLists/shopping_lists_cubit.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => RecipeCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<RecipeCubit, ShoppingListsState>(
          builder: (context, state) {
            switch (state.status) {
              case ShoppingListsStatus.loaded:
                return const _LoadedScreen();
              case ShoppingListsStatus.unintialized:
              case ShoppingListsStatus.loading:
                return const _LoadingScreen();
              case ShoppingListsStatus.error:
              default:
                return _ErrorScreen(state: state);
            }
          },
        ),
      );
    });
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Loading Shopping Lists...",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator(color: MealieColors.orange),
        ],
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.state});

  final ShoppingListsState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Error",
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 15),
          Text(state.errorMessage.toString())
        ],
      ),
    );
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen();

  @override
  Widget build(BuildContext context) {
    List<ShoppingList> shoppingLists =
        context.read<RecipeCubit>().state.shoppingLists ?? [];
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
      child: Column(
        children: [
          SizedBox(
            height: 125,
            child: SvgPicture.asset('assets/empty_cart.svg'),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 35,
              width: 100,
              decoration: const BoxDecoration(
                  color: MealieColors.green,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: InkWell(
                onTap: () => context.read<RecipeCubit>().createOverlay(context),
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
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: shoppingLists.length,
              itemBuilder: (context, index) {
                ShoppingList shoppingList = shoppingLists[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: _ShoppingListTile(
                    shoppingList: shoppingList,
                    onTap: () {
                      context.read<HomeCubit>().setScreen(
                          ShoppingListPage(shoppingList: shoppingList));
                    },
                    onDelete: () {
                      SnackBar snackBar = SnackBar(
                        content: const Text(
                            'Are you sure you want to delete this shopping list?'),
                        action: SnackBarAction(
                          label: "Yes",
                          onPressed: () => context
                              .read<RecipeCubit>()
                              .deleteShoppingList(shoppingList.id),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ShoppingListTile extends StatelessWidget {
  const _ShoppingListTile({
    required this.shoppingList,
    required this.onTap,
    required this.onDelete,
  });

  final ShoppingList shoppingList;
  final Function onTap;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onTap(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 5,
                color: Colors.orange,
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.shopping_cart,
                color: Colors.black.withOpacity(0.5),
              ),
              const SizedBox(width: 10),
              Text(
                shoppingList.name.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const Spacer(flex: 1),
              IconButton(
                onPressed: () => onDelete(),
                icon: Icon(
                  Icons.delete,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
