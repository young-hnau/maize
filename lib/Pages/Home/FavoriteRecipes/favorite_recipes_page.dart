import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/FavoriteRecipes/favorite_recipes_cubit.dart';
import 'package:maize/Widgets/recipe_card/recipe_card_widget.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

class FavoriteRecipesPage extends StatelessWidget {
  const FavoriteRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => FavoriteRecipesCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<FavoriteRecipesCubit, FavoriteRecipesState>(
          builder: (context, state) {
            switch (state.status) {
              case FavoriteRecipesStatus.loaded:
                return _LoadedScreen(favorites: state.favoriteRecipes ?? []);
              case FavoriteRecipesStatus.ready:
              case FavoriteRecipesStatus.loading:
                return const _LoadingScreen();
              case FavoriteRecipesStatus.error:
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
            "Loading Favorite Recipes...",
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

  final FavoriteRecipesState state;

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
          Text(state.errorMessage ?? "An unknown error occured.")
        ],
      ),
    );
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen({required this.favorites});

  final List<Recipe?> favorites;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 24),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Icon(
                Icons.favorite,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 10),
              Text(
                "User Favorites",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                Recipe? favorite = favorites[index];
                if (favorite == null) return Container();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: RecipeCard(
                    recipe: favorite,
                    isFavorite: true,
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
