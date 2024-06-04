part of 'recipe_page.dart';

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen({
    required this.recipeCubit,
    required this.appBloc,
    required this.recipe,
  });

  final RecipeCubit recipeCubit;
  final AppBloc appBloc;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        appBloc.repo.uri.replace(path: recipe.imagePath).toString();

    return RefreshIndicator(
      onRefresh: () => recipeCubit.getRecipe(),
      child: ListView(
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
          if (recipe.description != null && recipe.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(recipe.description.toString()),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (recipe.prepTime != null && recipe.prepTime!.isNotEmpty)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                        color: MealieColors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.clock,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Prep Time | ${recipe.prepTime}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              if (recipe.prepTime != null &&
                  recipe.performTime != null &&
                  recipe.performTime!.isNotEmpty)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: const BoxDecoration(
                        color: MealieColors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.clock,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 10),
                          // NOTE: Unsure why, but the API seems to be using prepTime when the UI referes to "Cook Time"
                          Text(
                            "Cook Time | ${recipe.performTime}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StarRating(
                rating: recipeCubit.state.userRating?.rating ?? 0.0,
                iconSize: 25,
                spacing: 0,
                setRating: recipeCubit.setRating,
              ),
              (recipe.rating != null)
                  ? Text("Average Rating: ${recipe.rating}")
                  : Container(),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.black.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 10),
          recipe.recipeYield == null || recipe.recipeYield!.isEmpty
              ? Container()
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    color: MealieColors.darkRed,
                    margin: const EdgeInsets.only(left: 15.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        recipe.recipeYield.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => recipeCubit.createOverlay(context),
                        icon: const Icon(Icons.add_shopping_cart)),
                    IconButton(
                        onPressed: () =>
                            recipeCubit.copyIngredientsToClipboard(),
                        icon: const Icon(Icons.copy)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: recipe.recipeIngredient!.length,
            itemBuilder: (context, index) {
              Ingredient? ingredient = recipe.recipeIngredient?[index];
              if (ingredient == null) {
                return Container();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ingredient.title != null && ingredient.title!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        ingredient.title.toString(),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: recipeCubit.state.checkedIngredients
                                  ?.contains(ingredient.referenceId) ??
                              false,
                          onChanged: (v) {
                            recipeCubit.checkIngredient(ingredient);
                          }),
                      Expanded(
                        child: Text(
                          recipe.recipeIngredient![index].note.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: recipe.recipeInstructions!.length,
              itemBuilder: (context, index) {
                Instruction? instruction = recipe.recipeInstructions?[index];
                if (instruction == null) {
                  return Container();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (instruction.title != null && instruction.title != "")
                      Card(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 4, top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          color: MealieColors.orange,
                          child: Text(
                            instruction.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Step: ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(instruction.text.toString()),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          recipe.tags != null && recipe.tags!.isNotEmpty
              ? _TagsCard(recipeCubit: recipeCubit)
              : Container(),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16), child: Divider()),
          recipe.nutrition != null && recipe.settings?.showNutrition == true
              ? Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Nutrition"),
                        const Divider(),
                        _NutritionInformationText(
                          nutritionId: "Calories",
                          quantity: recipe.nutrition!.calories ?? "",
                          unit: "calories",
                        ),
                        _NutritionInformationText(
                          nutritionId: "Fat",
                          quantity: recipe.nutrition!.fatContent ?? "",
                          unit: "grams",
                        ),
                        _NutritionInformationText(
                          nutritionId: "Fiber",
                          quantity: recipe.nutrition!.fiberContent ?? "",
                          unit: "grams",
                        ),
                        _NutritionInformationText(
                          nutritionId: "Protein",
                          quantity: recipe.nutrition!.proteinContent ?? "",
                          unit: "grams",
                        ),
                        _NutritionInformationText(
                          nutritionId: "Sodium",
                          quantity: recipe.nutrition!.sodiumContent ?? "",
                          unit: "milligrams",
                        ),
                        _NutritionInformationText(
                          nutritionId: "Sugar",
                          quantity: recipe.nutrition!.sugarContent ?? "",
                          unit: "grams",
                        ),
                        _NutritionInformationText(
                          nutritionId: "Carbohydrate",
                          quantity: recipe.nutrition!.carbohydrateContent ?? "",
                          unit: "grams",
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          recipe.orgURL != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    height: 35,
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: MealieColors.darkRed,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await launchUrl(Uri.parse(recipe.orgURL!));
                      },
                      child: const Text(
                        "Original URL",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class _NutritionInformationText extends StatelessWidget {
  const _NutritionInformationText({
    required this.nutritionId,
    required this.quantity,
    required this.unit,
  });

  final String nutritionId;
  final String quantity;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          nutritionId,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          "$quantity $unit",
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }
}

class _TagsCard extends StatelessWidget {
  const _TagsCard({
    required this.recipeCubit,
  });

  final RecipeCubit recipeCubit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tags",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.black.withOpacity(0.5)),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 35,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: recipeCubit.state.recipe?.tags?.length ?? 0,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      color: MealieColors.darkBlue,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        recipeCubit.state.recipe?.tags?[index].name ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
