import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealie_mobile/app/app_bloc.dart';

part 'create_overlay_state.dart';

class CreateOverlayCubit extends Cubit<CreateOverlayState> {
  CreateOverlayCubit({required this.appBloc})
      : super(const CreateOverlayState(
          status: CreateOverlayStatus.ready,
        )) {
    _initialize();
  }

  final AppBloc appBloc;

  Future<void> _initialize() async {}
}
