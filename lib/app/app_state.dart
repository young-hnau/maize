part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  loading,
  unauthenticated,
  uninitialized,
  initialized,
  noURI,
}

class AppState extends Equatable {
  const AppState._(
      {required this.status,
      User? user,
      required MealieRepository mealieRepository})
      : user = user ?? User.empty,
        _mealieRepository = mealieRepository;

  AppState.uninitialized()
      : this._(
            status: AppStatus.uninitialized,
            mealieRepository: MealieRepository(uri: Uri()));

  AppState.noURI()
      : this._(
            status: AppStatus.noURI,
            mealieRepository: MealieRepository(uri: Uri()));

  final AppStatus status;
  final User user;
  final MealieRepository _mealieRepository;

  AppState copyWith({
    AppStatus? status,
    User? user,
    MealieRepository? mealieRepository,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      mealieRepository: mealieRepository ?? _mealieRepository,
    );
  }

  @override
  List<Object?> get props => [status, user, _mealieRepository];
}
