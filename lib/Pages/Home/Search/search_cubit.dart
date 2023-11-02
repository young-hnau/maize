import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
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

  Future<void> _initialize() async {
    state.pagingController
        .addPageRequestListener((pageKey) => getRecipes(pageKey: pageKey));
  }

  Future<void> getRecipes({int pageKey = 1}) async {
    try {
      List<Recipe>? recipes = await appBloc.repo.getAllRecipes(
        search: _searchQuery,
        page: pageKey,
        perPage: _pageSize,
      );

      if (recipes == null) {
        throw Exception("An unknown error occuried while getting recipes");
      }

      if (recipes.length < _pageSize) {
        state.pagingController.appendLastPage(recipes);
      } else {
        state.pagingController.appendPage(recipes, pageKey + 1);
      }
    } on Exception catch (err) {
      emit(state.copyWith(
          status: SearchStatus.error, errorMessage: err.toString()));
    }
  }

  void searchRecipes(String? search) {
    _searchQuery = search;
    state.pagingController.refresh();
  }
}
