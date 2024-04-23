part of 'drawer_cubit.dart';

enum DrawerStatus {
  ready,
  loading,
  error,
}

class DrawerState extends Equatable {
  const DrawerState({
    required this.status,
    this.errorMessage,
  });

  final DrawerStatus status;
  final String? errorMessage;

  DrawerState copyWith({
    DrawerStatus? status,
    String? errorMessage,
    OverlayEntry? createOverlay,
  }) {
    return DrawerState(
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
