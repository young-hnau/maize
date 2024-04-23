import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealie_mobile/Pages/Home/Page/Drawer/CreateOverlay/create_overlay_cubit.dart';
import 'package:mealie_mobile/Pages/Home/Page/Drawer/drawer_cubit.dart';
import 'package:mealie_mobile/app/app_bloc.dart';

class CreateOverlay extends OverlayEntry {
  final DrawerCubit drawerCubit;
  CreateOverlay({required this.drawerCubit})
      : super(
          builder: (context) {
            return Material(
              color: Colors.transparent,
              child: BlocProvider(
                create: (_) => CreateOverlayCubit(
                  appBloc: context.read<AppBloc>(),
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onTap: drawerCubit.removeCreateOverlay,
                  child: BlocBuilder<CreateOverlayCubit, CreateOverlayState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case CreateOverlayStatus.ready:
                          return _LoadedScreen();
                        default:
                          return _ErrorScreen();
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
}

class _LoadedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        elevation: 5,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: 100,
          child: Column(
            children: [
              Text("Import"),
              Text("Create"),
              Text("Cookbook"),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
