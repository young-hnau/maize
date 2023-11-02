import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mealie_mobile/Pages/Home/Search/search_page.dart';
import 'package:mealie_mobile/app/app_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.appBloc})
      : super(HomeState(status: HomeStatus.ready, onScreen: SearchPage())) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {
    appBloc.repo.errorStream.stream.listen((message) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: message.toString(),
      ));
    });
  }

  void setScreen(Widget screen) {
    emit(state.copyWith(status: state.status, onScreen: screen));
  }
}
