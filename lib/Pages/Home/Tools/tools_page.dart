import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Tools/tools_cubit.dart';

import 'package:maize/app/app_bloc.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => ToolsCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<ToolsCubit, ToolsState>(
          builder: (context, state) {
            return const Center(
              child: Text("Tools Page - Still Needs to be Implemented"),
            );
          },
        ),
      );
    });
  }
}
