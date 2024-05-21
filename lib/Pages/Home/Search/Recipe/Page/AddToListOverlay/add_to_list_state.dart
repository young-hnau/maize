part of 'add_to_list_cubit.dart';

enum AddToListStatus {
  loading,
  loaded,
  error,
}

class AddToListState extends Equatable {
  const AddToListState({
    required this.status,
    this.uri,
    this.errorMessage,
    this.shoppingLists,
    this.selectedList,
  });

  final AddToListStatus status;
  final Uri? uri;
  final String? errorMessage;
  final List<ShoppingList>? shoppingLists;
  final ShoppingList? selectedList;

  AddToListState copyWith({
    AddToListStatus? status,
    Uri? uri,
    String? errorMessage,
    List<ShoppingList>? shoppingLists,
    ShoppingList? selectedList,
  }) {
    return AddToListState(
      status: status ?? this.status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingLists: shoppingLists ?? this.shoppingLists,
      selectedList: selectedList ?? this.selectedList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        errorMessage,
        shoppingLists,
        selectedList,
      ];
}
