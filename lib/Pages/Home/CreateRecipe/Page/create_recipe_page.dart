import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maize/Pages/Home/CreateRecipe/Page/DropDownButton/drop_down_widget.dart';
import 'package:maize/Pages/Home/CreateRecipe/Page/create_recipe_cubit.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/app/app_bloc.dart';

class CreateRecipePage extends StatelessWidget {
  const CreateRecipePage({
    super.key,
    required this.homeCubit,
  });

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateRecipeCubit(
        appBloc: context.read<AppBloc>(),
        homeCubit: homeCubit,
      ),
      child: BlocBuilder<CreateRecipeCubit, CreateRecipeState>(
          builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Center(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/diet.svg",
                              width: 150,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Recipe Creation",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            const Text(
                              "Select one of the various ways to create a recipe",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: ImportTypeDropDown(),
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            const SizedBox(height: 20),
                            context.read<CreateRecipeCubit>().state.onScreen,
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
