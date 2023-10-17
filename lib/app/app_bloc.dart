import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mealie_repository/mealie_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.uninitialized()) {
    on<AppStarted>(_initializeApp);
    on<AppLogoutRequested>(_logout);
    on<AppUserChanged>(_appUserChanged);

    add(const AppStarted());
  }

  Future<void> _initializeApp(AppStarted event, Emitter<AppState> emit) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? uriString = p.getString("__self_hosted_uri__");

    if (uriString == null) {
      emit(state.copyWith(status: AppStatus.noURI));
    } else {
      final Uri uri = Uri.parse(uriString);
      final MealieRepository mealieRepository = MealieRepository(uri: uri);

      mealieRepository.authenticated.stream.listen((event) {
        if (event == false) {
          add(AppLogoutRequested());
        }
      });

      emit(state.copyWith(
          status: AppStatus.initialized, mealieRepository: mealieRepository));

      final String? token = p.getString("__user_token__");
      if (token == null || token == "null") {
        emit(state.copyWith(status: AppStatus.unauthenticated));
      } else {
        getRefreshToken(token);
      }
    }
  }

  Future<void> _logout(AppLogoutRequested event, Emitter<AppState> emit) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.remove("__user_token__");
    emit(state.copyWith(status: AppStatus.unauthenticated));
  }

  void refreshApp() {
    add(const AppStarted());
  }

  Future<void> getRefreshToken(String token) async {
    final String? refreshToken =
        await state.mealieRepository.getRefreshToken(token: token);

    if (refreshToken == null) {
      add(AppLogoutRequested());
    } else {
      _loadUser(token, refreshToken);
    }
  }

  Future<void> _loadUser(String token, String refreshToken) async {
    final User? user =
        await state.mealieRepository.getUser(token: refreshToken);

    if (user == null || user.isEmpty) {
      add(AppLogoutRequested());
    } else {
      state.mealieRepository.refreshToken.stream.listen(
        (event) =>
            add(AppUserChanged(user: state.user.copyWith(refreshToken: event))),
      );
      add(AppUserChanged(user: user));
    }
  }

  Future<void> _appUserChanged(
      AppUserChanged event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.authenticated, user: event.user));
  }
}
