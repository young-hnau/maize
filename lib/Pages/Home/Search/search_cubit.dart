import 'dart:async';

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.appBloc})
      : super(SearchState(
          status: SearchStatus.ready,
        )) {
    _initialize();
  }

  final AppBloc appBloc;
  final int _pageSize = 50;
  String? _searchQuery;
  CancelableOperation? searching;

  Future<void> _initialize() async {
    state.pagingController
        .addPageRequestListener((pageKey) => getRecipes(pageKey: pageKey));
    emit(state.copyWith(favorites: await appBloc.repo.getFavorites()));
  }

  Future<void> getRecipes({int pageKey = 1}) async {
    try {
      if (searching != null && !searching!.isCompleted) {
        searching!.cancel();
      }
      searching = CancelableOperation.fromFuture(appBloc.repo.getAllRecipes(
        search: _searchQuery,
        page: pageKey,
        perPage: _pageSize,
      ));

      searching?.value.then((value) {
        List<Recipe>? recipes = value;

        if (recipes == null) {
          throw Exception("An unknown error occuried while getting recipes");
        }

        if (recipes.length < _pageSize) {
          state.pagingController.appendLastPage(recipes);
        } else {
          state.pagingController.appendPage(recipes, pageKey + 1);
        }
      });
    } on Exception catch (err) {
      emit(state.copyWith(
          status: SearchStatus.error, errorMessage: err.toString()));
    }
  }

  void searchRecipes(String? search) {
    if (search != _searchQuery) {
      _searchQuery = search;
      state.pagingController.refresh();
    }
  }

  void clearSearch() {
    _searchQuery = null;
    state.pagingController.refresh();
  }
}
