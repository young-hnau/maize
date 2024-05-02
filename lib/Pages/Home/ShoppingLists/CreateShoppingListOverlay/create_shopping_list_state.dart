part of 'create_shopping_list_cubit.dart';

enum CreateShoppingListStatus {
  ready,
  error,
}

class CreateShoppingListState extends Equatable {
  const CreateShoppingListState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final CreateShoppingListStatus status;
  final Uri? uri;
  final String? errorMessage;

  CreateShoppingListState copyWith({
    required CreateShoppingListStatus status,
    Uri? uri,
    String? errorMessage,
  }) {
    return CreateShoppingListState(
      status: status,
      uri: uri ?? this.uri,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        uri,
        errorMessage,
      ];
}
