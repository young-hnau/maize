import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealie_mobile/Pages/Home/Page/Drawer/CreateOverlay/create_overlay_widget.dart';
import 'package:mealie_mobile/app/app_bloc.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit({required this.appBloc})
      : super(const DrawerState(status: DrawerStatus.ready)) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {}

  void removeCreateOverlay() {
    state.createOverlay!.remove();
    emit(state.copyWith(status: state.status, createOverlay: null));
  }

  void addCreateOverlay(BuildContext context) {
    OverlayEntry overlayEntry = CreateOverlay(drawerCubit: this);
    Overlay.of(context).insert(overlayEntry);

    emit(state.copyWith(status: state.status, createOverlay: overlayEntry));
  }
}
