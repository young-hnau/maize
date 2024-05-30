import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maize/Pages/Home/Search/search_page.dart';
import 'package:maize/app/app_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.appBloc, required BuildContext context})
      : super(HomeState(
            status: HomeStatus.ready,
            context: context,
            onScreen: SearchPage())) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {
    appBloc.repo.errorStream.stream.listen((message) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: message,
      ));
    });
  }

  void setScreen(Widget screen, {HomeStatus? status}) {
    emit(state.copyWith(status: status ?? state.status, onScreen: screen));
  }
}
