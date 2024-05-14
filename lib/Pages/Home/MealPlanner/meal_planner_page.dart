import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/MealPlanner/meal_planner_cubit.dart';
import 'package:maize/app/app_bloc.dart';

class MealPlannerPage extends StatelessWidget {
  const MealPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => MealPlannerCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<MealPlannerCubit, MealPlannerState>(
          builder: (context, state) {
            return const Center(
              child: Text("Meal Planner Page - Still Needs to be Implemented"),
            );
          },
        ),
      );
    });
  }
}
