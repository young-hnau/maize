part of 'create_shopping_item_cubit.dart';

enum CreateShoppingItemStatus {
  ready,
  error,
}

class CreateShoppingItemState extends Equatable {
  const CreateShoppingItemState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final CreateShoppingItemStatus status;
  final Uri? uri;
  final String? errorMessage;

  CreateShoppingItemState copyWith({
    required CreateShoppingItemStatus status,
    Uri? uri,
    String? errorMessage,
  }) {
    return CreateShoppingItemState(
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
