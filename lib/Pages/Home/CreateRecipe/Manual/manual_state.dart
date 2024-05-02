part of 'manual_cubit.dart';

enum ManualStatus {
  ready,
  loading,
  error,
}

class ManualState extends Equatable {
  ManualState({required this.status, this.errorMessage});

  final ManualStatus status;
  final TextEditingController textEditingController = TextEditingController();
  final String? errorMessage;

  ManualState copyWith({
    ManualStatus? status,
    String? errorMessage,
  }) {
    return ManualState(
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
