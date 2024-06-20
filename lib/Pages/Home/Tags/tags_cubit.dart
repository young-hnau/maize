import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit({required this.appBloc})
      : super(TagsState(
          status: TagsStatus.ready,
        )) {
    _initialize();
  }

  final AppBloc appBloc;
  String? _searchQuery;

  Future<void> _initialize() async {
    state.pagingController
        .addPageRequestListener((pageKey) => getTags(pageKey: pageKey));
  }

  Future<void> getTags({int pageKey = 1}) async {
    try {
      TagResponse? tagResponse = await appBloc.repo.getAllTags(
        search: _searchQuery,
        page: pageKey,
        perPage: 50,
      );

      if (tagResponse == null) {
        emit(state.copyWith(
            status: TagsStatus.error,
            errorMessage:
                "There was an error retrieving the tags from Mealie"));
        return;
      }

      if (tagResponse.next == null) {
        state.pagingController.appendLastPage(tagResponse.items);
      } else {
        state.pagingController.appendPage(tagResponse.items, pageKey + 1);
      }

      if (state.status != TagsStatus.ready) {
        emit(state.copyWith(status: TagsStatus.ready));
      }
    } on Exception catch (err) {
      emit(state.copyWith(
          status: TagsStatus.error, errorMessage: err.toString()));
    }
  }

  void searchTags(String? search) {
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
