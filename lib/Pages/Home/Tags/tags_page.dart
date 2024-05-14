import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Tags/tags_cubit.dart';

import 'package:maize/app/app_bloc.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => TagsCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<TagsCubit, TagsState>(
          builder: (context, state) {
            return const Center(
              child: Text("Tags Page - Still Needs to be Implemented"),
            );
          },
        ),
      );
    });
  }
}
