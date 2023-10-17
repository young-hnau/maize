part of 'meal_planner_cubit.dart';

enum MealPlannerStatus {
  ready,
  loading,
}

class MealPlannerState extends Equatable {
  const MealPlannerState({
    required this.status,
    this.uri,
    this.errorMessage,
  });

  final MealPlannerStatus status;
  final Uri? uri;
  final String? errorMessage;

  MealPlannerState copyWith({
    required MealPlannerStatus status,
    Uri? uri,
    String? errorMessage,
    bool? showPassword,
    bool? rememberMe,
  }) {
    return MealPlannerState(
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
