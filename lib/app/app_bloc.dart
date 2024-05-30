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
    on<UserLoggedIn>(_userLoggedIn);
    on<MealieURIUpdated>(_updateMealieRepoURI);

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

      _loadUser();
    }
  }

  Future<void> _logout(AppLogoutRequested event, Emitter<AppState> emit) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.remove("__access_token__");

    // state._mealieRepository.authenticated.close();
    // state._mealieRepository.errorStream.close();
    // state._mealieRepository.refreshToken.close();

    emit(state.copyWith(status: AppStatus.unauthenticated));
  }

  Future<void> _loadUser({String? token}) async {
    final User? user = await state._mealieRepository.getUser(token: token);

    if (user == null || user.isEmpty) {
      add(AppLogoutRequested());
    } else {
      state._mealieRepository.refreshToken.stream.listen(
        (event) =>
            add(AppUserChanged(user: state.user.copyWith(refreshToken: event))),
      );
      add(AppUserChanged(user: user));
    }
  }

  Future<void> _userLoggedIn(UserLoggedIn event, Emitter<AppState> emit) async {
    _loadUser(token: event.token);
  }

  Future<void> _appUserChanged(
      AppUserChanged event, Emitter<AppState> emit) async {
    emit(state.copyWith(status: AppStatus.authenticated, user: event.user));
  }

  Future<void> _updateMealieRepoURI(
      MealieURIUpdated event, Emitter<AppState> emit) async {
    emit(state.copyWith(
        mealieRepository: state._mealieRepository.copyWith(uri: event.uri)));
  }

  void refreshApp() {
    add(const AppStarted());
  }

  void updateMealieRepoURI(Uri uri) {
    add(MealieURIUpdated(uri: uri));
  }

  /// Returns an instance of MealieRepository with the most up to date token data
  MealieRepository get repo {
    return state._mealieRepository.copyWith(user: state.user);
  }
}

extension CubitExt<T> on Cubit<T> {
  void safeEmit(T state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }
}
