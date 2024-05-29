part of 'app_bloc.dart';

class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppLogoutRequested extends AppEvent {
  @override
  List<Object?> get props => [];
}

class AppUserChanged extends AppEvent {
  const AppUserChanged({
    required this.user,
  });
  final User user;

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends AppEvent {
  const UserUpdated({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

class LoadUser extends AppEvent {
  const LoadUser({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

class AppStarted extends AppEvent {
  const AppStarted();
}

class UserLoggedIn extends AppEvent {
  const UserLoggedIn({required this.token});

  final String token;

  @override
  List<Object?> get props => [token];
}

class MealieURIUpdated extends AppEvent {
  const MealieURIUpdated({required this.uri});

  final Uri uri;

  @override
  List<Object?> get props => [uri];
}
