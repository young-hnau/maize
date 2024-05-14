import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/Pages/Home/Categories/categories_cubit.dart';

import 'package:maize/app/app_bloc.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => CategoriesCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            return const Center(
              child: Text("Categories Page - Still Needs to be Implemented"),
            );
          },
        ),
      );
    });
  }
}
