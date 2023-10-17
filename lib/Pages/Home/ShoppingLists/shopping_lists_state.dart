part of 'shopping_lists_cubit.dart';

enum ShoppingListsStatus {
  unintialized,
  loaded,
  loading,
  error,
}

class ShoppingListsState extends Equatable {
  const ShoppingListsState({
    required this.status,
    this.uri,
    this.errorMessage,
    this.shoppingLists,
  });

  final ShoppingListsStatus status;
  final Uri? uri;
  final String? errorMessage;
  final List<ShoppingList>? shoppingLists;

  ShoppingListsState copyWith({
    required ShoppingListsStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
    List<ShoppingList>? shoppingLists,
  }) {
    return ShoppingListsState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingLists: shoppingLists ?? this.shoppingLists,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        errorMessage,
        shoppingLists,
      ];
}
