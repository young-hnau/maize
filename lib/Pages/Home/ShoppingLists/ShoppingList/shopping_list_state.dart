part of 'shopping_list_cubit.dart';

enum ShoppingListStatus {
  unintialized,
  loaded,
  loading,
  error,
}

class ShoppingListState extends Equatable {
  ShoppingListState({
    required this.status,
    this.uri,
    this.errorMessage,
    this.shoppingList,
    this.showChecked = false,
    this.overlayEntry,
    this.currentlyEditingIndex,
  });

  final ShoppingListStatus status;
  final Uri? uri;
  final String? errorMessage;
  final ShoppingList? shoppingList;
  final bool showChecked;
  final OverlayEntry? overlayEntry;
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  final int? currentlyEditingIndex;

  ShoppingListState copyWith({
    required ShoppingListStatus status,
    Uri? uri,
    String? errorMessage,
    ShoppingList? shoppingList,
    bool? showChecked,
    OverlayEntry? overlayEntry,
    int? currentlyEditingIndex,
  }) {
    return ShoppingListState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingList: shoppingList ?? this.shoppingList,
      showChecked: showChecked ?? this.showChecked,
      overlayEntry: overlayEntry ?? this.overlayEntry,
      currentlyEditingIndex:
          currentlyEditingIndex ?? this.currentlyEditingIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        errorMessage,
        shoppingList,
        showChecked,
        overlayEntry,
        shoppingList?.items?.map((e) => e.checked),
        currentlyEditingIndex,
      ];
}
