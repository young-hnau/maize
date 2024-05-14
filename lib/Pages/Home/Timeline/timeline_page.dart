import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Timeline/timeline_cubit.dart';
import 'package:maize/app/app_bloc.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => TimelineCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<TimelineCubit, TimelineState>(
          builder: (context, state) {
            return const Center(
              child: Text("Timeline Page - Still Needs to be Implemented"),
            );
          },
        ),
      );
    });
  }
}
