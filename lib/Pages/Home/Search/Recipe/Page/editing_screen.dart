part of 'recipe_page.dart';

class _EditingScreen extends StatelessWidget {
  const _EditingScreen({
    required this.appBloc,
    required this.recipe,
  });

  final AppBloc appBloc;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        appBloc.repo.uri.replace(path: recipe.imagePath).toString();

    TextEditingController recipeNameTFController =
        TextEditingController(text: recipe.name);
    TextEditingController recipeYieldTFController =
        TextEditingController(text: recipe.recipeYield);
    TextEditingController totalTimeTFController =
        TextEditingController(text: recipe.totalTime);
    TextEditingController prepTimeTFController =
        TextEditingController(text: recipe.prepTime);
    // NOTE: Unsure why, but the API seems to be using prepTime when the UI referes to "Cook Time"
    TextEditingController cookTimeTFController =
        TextEditingController(text: recipe.performTime);
    TextEditingController descriptionTFController =
        TextEditingController(text: recipe.description);

    return BlocBuilder<RecipeCubit, RecipeState>(
      buildWhen: (previous, current) => false,
      builder: (context, snapshot) {
        RecipeCubit recipeCubit = context.read<RecipeCubit>();

        return ListView(
          shrinkWrap: true,
          children: [
            _Header(
              imageUrl: imageUrl,
              recipeCubit: recipeCubit,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                recipe.name.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                // height: 30,
                child: TextField(
                  controller: recipeNameTFController,
                  decoration: const InputDecoration(
                    label: Text("Recipe Name"),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  onChanged: (value) => recipeCubit.updateRecipe(name: value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                child: TextField(
                  controller: recipeYieldTFController,
                  decoration: const InputDecoration(
                    label: Text("Servings"),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  onChanged: (value) =>
                      recipeCubit.updateRecipe(recipeYield: value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      child: TextField(
                        controller: totalTimeTFController,
                        decoration: const InputDecoration(
                          label: Text("Total Time"),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        onChanged: (value) =>
                            recipeCubit.updateRecipe(totalTime: value),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: SizedBox(
                      child: TextField(
                        controller: prepTimeTFController,
                        decoration: const InputDecoration(
                          label: Text("Prep Time"),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        onChanged: (value) =>
                            recipeCubit.updateRecipe(prepTime: value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                child: TextField(
                  controller: cookTimeTFController,
                  decoration: const InputDecoration(
                    label: Text("Cook Time"),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  // NOTE: Unsure why, but the API seems to be using prepTime when the UI referes to "Cook Time"
                  onChanged: (value) =>
                      recipeCubit.updateRecipe(performTime: value),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: descriptionTFController,
                minLines: 5,
                maxLines: 5,
                decoration: const InputDecoration(
                  label: Text("Description"),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                onChanged: (value) =>
                    recipeCubit.updateRecipe(description: value),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _ReorderableIngredients(
              recipe: recipe,
              recipeCubit: recipeCubit,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Instructions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _ReorderableInstructions(recipe: recipe, recipeCubit: recipeCubit),
          ],
        );
      },
    );
  }
}

class _ReorderableIngredients extends StatelessWidget {
  const _ReorderableIngredients({
    required this.recipe,
    required this.recipeCubit,
  });

  final Recipe recipe;
  final RecipeCubit recipeCubit;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: recipe.recipeIngredient!.length,
      onReorder: recipeCubit.reorderIngredients,
      itemBuilder: (context, index) {
        Ingredient? ingredient = recipe.recipeIngredient?[index];
        if (ingredient == null) {
          return Container(key: Key('$index'));
        }

        TextEditingController noteTFController =
            TextEditingController(text: ingredient.note.toString());

        TextEditingController titleTFController = TextEditingController(
            text: ingredient.title.toString() == " "
                ? null
                : ingredient.title.toString());
        return Column(
          key: Key('$index'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ingredient.title != null && ingredient.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: TextField(
                  controller: titleTFController,
                  onChanged: (value) =>
                      recipeCubit.updateIngredientTitle(index, value),
                  decoration: const InputDecoration(hintText: "Section Title"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
            if (ingredient.title != null && ingredient.title!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 0.5,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              controller: noteTFController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              onChanged: (value) => recipeCubit
                                  .updateIngredientNote(index, value),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => recipeCubit.deleteIngredient(index),
                        child: const FaIcon(FontAwesomeIcons.trash, size: 16),
                      ),
                      const SizedBox(width: 15),
                      MenuAnchor(
                        builder: (context, controller, child) {
                          return InkWell(
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            child: const FaIcon(
                                FontAwesomeIcons.ellipsisVertical,
                                size: 16),
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                              child: TextButton(
                            child: const Text("Toggle Section",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () =>
                                recipeCubit.toggleIngredientSection(index),
                          ))
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(height: 0.5, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReorderableInstructions extends StatelessWidget {
  const _ReorderableInstructions({
    required this.recipe,
    required this.recipeCubit,
  });

  final Recipe recipe;
  final RecipeCubit recipeCubit;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: recipe.recipeInstructions!.length,
      onReorder: recipeCubit.reorderInstructions,
      itemBuilder: (context, index) {
        Instruction? instruction = recipe.recipeInstructions?[index];
        if (instruction == null) {
          return Container(key: Key('$index'));
        }

        TextEditingController titleTFController =
            TextEditingController(text: instruction.title.toString());
        TextEditingController noteTFController =
            TextEditingController(text: instruction.text.toString());

        return Column(
          key: Key('$index'),
          children: [
            if (instruction.title != null && instruction.title != "")
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(
                    left: 8, right: 8, bottom: 4, top: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  width: double.infinity,
                  color: MealieColors.orange,
                  child: TextField(
                    controller: titleTFController,
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    onChanged: (value) =>
                        recipeCubit.updateInstructionTitle(index, value),
                  ),
                ),
              ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_handle),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Step: ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => recipeCubit.deleteInstruction(index),
                          child: const FaIcon(FontAwesomeIcons.trash, size: 16),
                        ),
                        const SizedBox(width: 15),
                        MenuAnchor(
                          builder: (context, controller, child) {
                            return InkWell(
                              onTap: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              child: const FaIcon(
                                  FontAwesomeIcons.ellipsisVertical,
                                  size: 16),
                            );
                          },
                          menuChildren: [
                            MenuItemButton(
                                child: TextButton(
                              child: const Text("Toggle Section",
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () =>
                                  recipeCubit.toggleInstructionSection(index),
                            ))
                          ],
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteTFController,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
