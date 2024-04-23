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
    this.createOverlay,
  });

  final DrawerStatus status;
  final String? errorMessage;
  final OverlayEntry? createOverlay;

  DrawerState copyWith({
    DrawerStatus? status,
    String? errorMessage,
    OverlayEntry? createOverlay,
  }) {
    return DrawerState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createOverlay: createOverlay ?? this.createOverlay,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        createOverlay,
      ];
}
