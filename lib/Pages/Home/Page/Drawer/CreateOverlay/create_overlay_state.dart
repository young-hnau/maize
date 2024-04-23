part of 'create_overlay_cubit.dart';

enum CreateOverlayStatus {
  ready,
  loading,
  error,
}

class CreateOverlayState extends Equatable {
  const CreateOverlayState({
    required this.status,
    this.errorMessage,
  });

  final CreateOverlayStatus status;
  final String? errorMessage;

  CreateOverlayState copyWith({
    CreateOverlayStatus? status,
    String? errorMessage,
  }) {
    return CreateOverlayState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
