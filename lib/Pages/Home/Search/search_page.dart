import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maize/Pages/Home/Search/search_cubit.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/Widgets/recipe_card/recipe_card_widget.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';
import 'package:async/async.dart';

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
                return RecipeCard(
                  recipe: recipe,
                  isFavorite: searchCubit.state.favorites!
                      .map((f) => f?.recipeId)
                      .toList()
                      .contains(recipe.id),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchTextField extends StatefulWidget {
  const _SearchTextField({
    required this.searchCubit,
    required this.tfController,
  });

  final SearchCubit searchCubit;
  final TextEditingController tfController;

  @override
  State<StatefulWidget> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  @override
  Widget build(BuildContext context) {
    final RestartableTimer timer =
        RestartableTimer(const Duration(seconds: 1), () {
      if (widget.tfController.text.isNotEmpty) {
        widget.searchCubit.searchRecipes(widget.tfController.value.text);
      }
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: TextField(
          controller: widget.tfController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search...",
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.tfController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.tfController.clear();
                      widget.searchCubit.clearSearch();
                    },
                    icon: const Icon(Icons.clear))
                : null,
          ),
          onChanged: (query) {
            // Wait until 1 second has passed after final keypress before searching
            timer.reset();
            setState(() {});
          },
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
