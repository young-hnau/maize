import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit({required this.appBloc})
      : super(const TimelineState(
          status: TimelineStatus.ready,
        ));

  final AppBloc appBloc;

  void reset() {
    emit(state.copyWith(status: TimelineStatus.ready));
  }

  Future<void> logout() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    p.remove('__access_token__');
    appBloc.refreshApp();
  }
}
