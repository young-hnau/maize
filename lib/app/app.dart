import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/app/routes.dart';
import 'package:maize/colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        showPerformanceOverlay: false,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
              primary: MealieColors.orange, secondary: MealieColors.orange),
        ),
        home: FlowBuilder<AppStatus>(
          state: context.select((AppBloc bloc) => bloc.state.status),
          onGeneratePages: (state, pages) =>
              onGenerateAppViewPages(state, pages),
        ));
  }
}
