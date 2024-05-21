part of 'search_cubit.dart';

enum SearchStatus {
  ready,
  error,
}

class SearchState extends Equatable {
  SearchState({
    required this.status,
    this.errorMessage,
    this.updateAt,
    this.searchQuery,
    this.favorites,
    PagingController<int, Recipe>? pagingController,
  }) : pagingController =
            pagingController ?? PagingController<int, Recipe>(firstPageKey: 1);

  final SearchStatus status;
  final String? errorMessage;
  final DateTime? updateAt;
  final PagingController<int, Recipe> pagingController;
  final String? searchQuery;
  final List<Favorites?>? favorites;

  SearchState copyWith({
    SearchStatus? status,
    Uri? uri,
    String? errorMessage,
    List<Recipe>? recipes,
    DateTime? updateAt,
    String? token,
    String? searchQuery,
    List<Favorites?>? favorites,
  }) {
    return SearchState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      updateAt: updateAt ?? this.updateAt,
      pagingController: pagingController,
      searchQuery: searchQuery ?? this.searchQuery,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        updateAt,
        pagingController,
        searchQuery,
        favorites,
      ];
}
