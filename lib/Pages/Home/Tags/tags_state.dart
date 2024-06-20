part of 'tags_cubit.dart';

enum TagsStatus {
  ready,
  loading,
  error,
}

class TagsState extends Equatable {
  TagsState({
    required this.status,
    this.uri,
    this.errorMessage,
    PagingController<int, Tag>? pagingController,
    this.tagResponse,
  }) : pagingController =
            pagingController ?? PagingController<int, Tag>(firstPageKey: 1);

  final TagsStatus status;
  final Uri? uri;
  final PagingController<int, Tag> pagingController;
  final TagResponse? tagResponse;
  final String? errorMessage;

  TagsState copyWith({
    required TagsStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    TagResponse? tagResponse,
    bool? rememberMe,
  }) {
    return TagsState(
      status: status,
      uri: uri ?? this.uri,
      pagingController: pagingController,
      tagResponse: tagResponse ?? this.tagResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        pagingController,
        tagResponse,
        errorMessage,
      ];
}
