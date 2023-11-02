import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mealie_mobile/Pages/Home/Search/Recipe/Page/recipe_page.dart';
import 'package:mealie_mobile/Pages/Home/Search/search_cubit.dart';
import 'package:mealie_mobile/Pages/Home/home_cubit.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_mobile/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final TextEditingController tfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => SearchCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
              switch (state.status) {
                case SearchStatus.ready:
                  return _LoadedScreen(
                    searchCubit: context.read<SearchCubit>(),
                    appBloc: context.read<AppBloc>(),
                    tfController: tfController,
                    homeCubit: context.read<HomeCubit>(),
                  );
                case SearchStatus.error:
                  return _ErrorScreen(state: state);
              }
            });
          },
        ),
      );
    });
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen(
      {required this.searchCubit,
      required this.appBloc,
      required this.tfController,
      required this.homeCubit});

  final SearchCubit searchCubit;
  final AppBloc appBloc;
  final TextEditingController tfController;
  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          Future.sync(() => searchCubit.state.pagingController.refresh()),
      child: ListView(
        shrinkWrap: true,
        children: [
          _SearchTextField(
            searchCubit: searchCubit,
            tfController: tfController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PagedListView<int, Recipe>(
              pagingController: searchCubit.state.pagingController,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate<Recipe>(
                  itemBuilder: (context, recipe, index) {
                return _RecipeCard(
                  recipe: recipe,
                  appBloc: appBloc,
                  homeCubit: homeCubit,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.recipe,
    required this.appBloc,
    required this.homeCubit,
  });

  final Recipe recipe;
  final AppBloc appBloc;
  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        appBloc.repo.uri.replace(path: recipe.imagePath).toString();
    return InkWell(
      onTap: () => homeCubit.setScreen(RecipePage(recipe: recipe)),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    fit: BoxFit.cover,
                    "assets/mealie_logo.svg",
                    height: 120,
                    colorFilter: const ColorFilter.mode(
                        MealieColors.orange, BlendMode.srcIn),
                  );
                },
              ),
            ),
            SizedBox(
              height: 100,
              width: 243,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      recipe.name.toString(),
                      maxLines: 2,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: MealieColors.red,
                            ),
                            iconSize: 15,
                            onPressed: () {
                              const SnackBar snackBar = SnackBar(
                                content: Text(
                                  'This feature has not yet been implemented.',
                                ),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                          ),
                          _StarRating(recipe: recipe),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          const SnackBar snackBar = SnackBar(
                            content: Text(
                              'This feature has not yet been implemented.',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.ellipsis,
                          color: MealieColors.orange,
                          size: 18,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List<Widget>.generate(
            recipe.rating ?? 0,
            (index) => const Icon(
              Icons.star,
              color: MealieColors.red,
              size: 15,
            ),
          ),
        ),
        Row(
          children: List<Widget>.generate(
            5 - (recipe.rating ?? 0),
            (index) => const Icon(
              Icons.star_border,
              color: MealieColors.peach,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.searchCubit,
    required this.tfController,
  });

  final SearchCubit searchCubit;
  final TextEditingController tfController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: TextField(
          controller: tfController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search...",
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: tfController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      tfController.clear();
                      searchCubit.searchRecipes('');
                    },
                    icon: const Icon(Icons.clear))
                : null,
          ),
          onChanged: searchCubit.searchRecipes,
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.state});

  final SearchState state;

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
