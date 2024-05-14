import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'meal_planner_state.dart';

class MealPlannerCubit extends Cubit<MealPlannerState> {
  MealPlannerCubit({required this.appBloc})
      : super(const MealPlannerState(
          status: MealPlannerStatus.ready,
        ));

  final AppBloc appBloc;

  void reset() {
    emit(state.copyWith(status: MealPlannerStatus.ready));
  }

  Future<void> logout() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    p.remove('__access_token__');
    appBloc.refreshApp();
  }
}
