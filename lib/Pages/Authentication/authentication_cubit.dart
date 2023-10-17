import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({required this.appBloc})
      : super(const AuthenticationState(status: AuthenticationStatus.ready)) {
    _initialize();
  }

  final AppBloc appBloc;
  StreamSubscription? streamSub;

  void _initialize() {
    streamSub =
        appBloc.state.mealieRepository.errorStream.stream.listen((message) {
      emit(state.copyWith(
        status: AuthenticationStatus.invalid,
        errorMessage: message.toString(),
      ));
    });
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));

    if (!appBloc.state.mealieRepository.uri.isAbsolute) {
      emit(state.copyWith(
          status: AuthenticationStatus.invalid,
          errorMessage: "No domain has been provided."));
      return;
    }
    final String? token = await appBloc.state.mealieRepository.getToken(
        username: username, password: password, save: state.rememberMe);

    emit(state.copyWith(status: AuthenticationStatus.valid));

    await Future.delayed(const Duration(milliseconds: 500));

    if (streamSub != null) {
      streamSub!.cancel();
    }

    appBloc.getRefreshToken(token.toString());
  }

  void reset() {
    emit(state.copyWith(status: AuthenticationStatus.ready));
  }

  Future<void> resetURI() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    p.remove("__self_hosted_uri__");
    appBloc.refreshApp();
  }

  void togglePassword() {
    emit(state.copyWith(
        status: state.status, showPassword: !state.showPassword));
  }

  void toggleRememberMe() {
    emit(state.copyWith(status: state.status, rememberMe: !state.rememberMe));
  }
}
