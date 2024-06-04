import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maize/Pages/Home/ShoppingLists/ShoppingList/shopping_list_cubit.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({
    super.key,
    required this.shoppingList,
  });

  final ShoppingList shoppingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          return BlocProvider(
            create: (_) => ShoppingListCubit(
                appBloc: context.read<AppBloc>(), shoppingList: shoppingList),
            child: BlocBuilder<ShoppingListCubit, ShoppingListState>(
              builder: (context, state) {
                switch (state.status) {
                  case ShoppingListStatus.loaded:
                    return _LoadedScreen(
                      shoppingListCubit: context.read<ShoppingListCubit>(),
                      homeCubit: context.read<HomeCubit>(),
                    );
                  case ShoppingListStatus.unintialized:
                  case ShoppingListStatus.loading:
                    return const _LoadingScreen();
                  case ShoppingListStatus.error:
                  default:
                    return _ErrorScreen(state: state);
                }
              },
            ),
          );
        });
      }),
    );
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
            "Loading Shopping List...",
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

  final ShoppingListState state;

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
  const _LoadedScreen({
    required this.shoppingListCubit,
    required this.homeCubit,
  });

  final ShoppingListCubit shoppingListCubit;
  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    List<ShoppingListItem> shoppingListItems =
        context.read<ShoppingListCubit>().state.shoppingList?.items ?? [];
    List<ShoppingListItem> uncheckedItems = shoppingListItems
        .map((ShoppingListItem item) {
          if (!item.checked) return item;
        })
        .whereType<ShoppingListItem>()
        .toList();
    List<ShoppingListItem> checkedItems = shoppingListItems
        .map((ShoppingListItem item) {
          if (item.checked) return item;
        })
        .whereType<ShoppingListItem>()
        .toList();

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => shoppingListCubit.getShoppingList(),
          child: ListView(
            shrinkWrap: false,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 125,
                child: SvgPicture.asset('assets/empty_cart.svg'),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                child: Divider(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: uncheckedItems.length,
                  itemBuilder: (context, index) {
                    ShoppingListItem shoppingListItem = uncheckedItems[index];
                    return _ShoppingItemTile(
                      item: shoppingListItem,
                      shoppingListCubit: shoppingListCubit,
                    );
                  },
                ),
              ),
              shoppingListCubit.state.showChecked && checkedItems.isNotEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          height: 40,
                          width: 225,
                          decoration: const BoxDecoration(
                              color: MealieColors.brightRed,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: InkWell(
                            onTap: shoppingListCubit.deleteCheckedItems,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "Delete Checked Items",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              shoppingListCubit.state.showChecked
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: checkedItems.length,
                        itemBuilder: (context, index) {
                          ShoppingListItem shoppingListItem =
                              checkedItems[index];
                          return _ShoppingItemTile(
                            item: shoppingListItem,
                            shoppingListCubit: shoppingListCubit,
                          );
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 50),
            ],
          ),
        ),
        shoppingListCubit.state.keyboardVisibilityController.isVisible
            ? Container()
            : Align(
                alignment: Alignment.bottomRight,
                child: _BottomButtons(
                  shoppingListCubit: shoppingListCubit,
                  homeCubit: homeCubit,
                ),
              ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.shoppingListCubit,
    required this.homeCubit,
  });

  final ShoppingListCubit shoppingListCubit;
  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 35,
            width: 100,
            decoration: const BoxDecoration(
                color: MealieColors.orange,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: InkWell(
              onTap: () => shoppingListCubit.toggleShowChecked(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: FaIcon(
                        shoppingListCubit.state.showChecked
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      shoppingListCubit.state.showChecked ? "Hide" : "Show",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 35,
            width: 100,
            decoration: const BoxDecoration(
                color: MealieColors.green,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: InkWell(
              onTap: () => shoppingListCubit.createOverlay(context),
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
        ],
      ),
    );
  }
}

class _ShoppingItemTile extends StatelessWidget {
  const _ShoppingItemTile({
    required this.item,
    required this.shoppingListCubit,
  });

  final ShoppingListItem item;
  final ShoppingListCubit shoppingListCubit;

  void onDelete(BuildContext context) {
    final SnackBar snackBar = SnackBar(
      content: Text('Are you sure you want to delete ${item.note}?'),
      action: SnackBarAction(
        label: "Yes",
        onPressed: () {
          shoppingListCubit.deleteItem(item);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteTFController =
        TextEditingController(text: item.note);
    final TextEditingController quantityTFController =
        TextEditingController(text: item.quantity.toInt().toString());
    if ((item.extras! as Map<String, dynamic>)['editing'] ?? false) {
      return CurrentlyEditingItemTile(
        shoppingListCubit: shoppingListCubit,
        item: item,
        noteTFController: noteTFController,
        quantityTFController: quantityTFController,
        onClose: () => shoppingListCubit.toggleEditing(item),
        onSave: () => shoppingListCubit.updateItem(
          item,
          note: noteTFController.value.text,
          quantity: double.parse(quantityTFController.value.text),
        ),
      );
    }
    return InkWell(
      onTap: () => shoppingListCubit.toggleEditing(item),
      child: _ItemTile(
        onChecked: () => shoppingListCubit.checkItem(item),
        item: item,
        onDelete: () => onDelete(context),
        shoppingListCubit: shoppingListCubit,
      ),
    );
  }
}

class CurrentlyEditingItemTile extends StatelessWidget {
  const CurrentlyEditingItemTile({
    super.key,
    required this.shoppingListCubit,
    required this.item,
    this.title,
    required this.onClose,
    required this.onSave,
    required this.noteTFController,
    required this.quantityTFController,
  });

  final ShoppingListItem item;
  final String? title;
  final ShoppingListCubit shoppingListCubit;
  final Function onSave;
  final Function onClose;
  final TextEditingController noteTFController;
  final TextEditingController quantityTFController;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry> items = [
      const DropdownMenuEntry(
        value: 1,
        label: "Not Yet Implemented",
      ),
      const DropdownMenuEntry(
        value: 1,
        label: "Not Yet Implemented 2",
      ),
      const DropdownMenuEntry(
        value: 1,
        label: "Not Yet Implemented 3",
      ),
    ];

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (title != null && title!.isNotEmpty)
                Text(
                  title.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note",
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                  SizedBox(
                    height: 30,
                    child: TextField(
                      controller: noteTFController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Qty",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                      SizedBox(
                        width: 50,
                        height: 30,
                        child: TextField(
                          controller: quantityTFController,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 30),
                  Row(children: [
                    const FaIcon(FontAwesomeIcons.tag),
                    const SizedBox(width: 20),
                    SizedBox(
                        width: 200,
                        child: DropdownMenu(
                          inputDecorationTheme: const InputDecorationTheme(
                              border: InputBorder.none),
                          hintText: "Label",
                          dropdownMenuEntries: items,
                        ))
                  ])
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => onClose(),
                      icon: const Icon(Icons.close)),
                  IconButton(
                      onPressed: () => onSave(), icon: const Icon(Icons.save)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.onChecked,
    required this.item,
    required this.onDelete,
    required this.shoppingListCubit,
  });

  final Function onChecked;
  final ShoppingListItem item;
  final Function onDelete;
  final ShoppingListCubit shoppingListCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(value: item.checked, onChanged: (_) => onChecked()),
                const SizedBox(width: 10),
                Expanded(
                  flex: 999,
                  child: Text(
                    item.note,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                if (item.quantity > 1) const SizedBox(width: 10),
                if (item.quantity > 1) Text("x${item.quantity}"),
                const Spacer(flex: 1),
                (item.recipeReferences != null &&
                        item.recipeReferences!.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          final List<RecipeReference> recipeReferences =
                              shoppingListCubit
                                  .state.shoppingList!.recipeReferences;
                          final List<String?> linkedRecipeReferenceIDs = item
                              .recipeReferences!
                              .map((recipeElement) => recipeElement?.recipeId)
                              .toList();
                          final List<RecipeReference> linkedRecipeReferences =
                              recipeReferences
                                  .where(
                                    (element) => linkedRecipeReferenceIDs
                                        .contains(element.recipeId),
                                  )
                                  .toList();
                          final SnackBar snackBar = SnackBar(
                            content: Text(
                                'Linked to: \n- ${linkedRecipeReferences.map((element) => element.recipe?.name).join('\n- ')}'),
                          );

                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: Icon(
                          FontAwesomeIcons.kitchenSet,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      )
                    : Container(),
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
        ],
      ),
    );
  }
}
