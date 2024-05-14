import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit({required this.appBloc})
      : super(const DrawerState(status: DrawerStatus.ready)) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {}
}
