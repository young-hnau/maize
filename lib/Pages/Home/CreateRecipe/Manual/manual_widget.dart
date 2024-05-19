import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maize/Pages/Home/CreateRecipe/Manual/manual_cubit.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';

class ManualWidget extends StatelessWidget {
  const ManualWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManualCubit(
        appBloc: context.read<AppBloc>(),
        homeCubit: context.read<HomeCubit>(),
      ),
      child: BlocBuilder<ManualCubit, ManualState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Create Recipe",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      "Create a recipe by providing the name. All recipes must have unique names."),
                  const SizedBox(height: 10),
                  _RecipeManualTextFormField(
                    manualCubit: context.read<ManualCubit>(),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: MealieColors.green,
                      ),
                      child: InkWell(
                        radius: 20,
                        onTap: context.read<ManualCubit>().create,
                        child: state.status == ManualStatus.loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Create",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecipeManualTextFormField extends StatelessWidget {
  const _RecipeManualTextFormField({
    required this.manualCubit,
  });

  final ManualCubit manualCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TextFormFieldCubit(manualCubit: manualCubit),
      child: BlocBuilder<TextFormFieldCubit, TextFormFieldState>(
        builder: (context, state) {
          return TextFormField(
            controller: manualCubit.state.textEditingController,
            autocorrect: false,
            onFieldSubmitted: (_) => manualCubit.create(),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 10.0),
                child: SvgPicture.asset(
                  "assets/mealie_logo.svg",
                  colorFilter: const ColorFilter.mode(
                    MealieColors.orange,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(maxHeight: 30),
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(width: 0.0, style: BorderStyle.none),
              ),
              filled: true,
              labelText: 'Recipe Name',
              labelStyle: const TextStyle(
                color: MealieColors.orange,
              ),
              floatingLabelStyle: const TextStyle(
                color: MealieColors.orange,
                fontWeight: FontWeight.bold,
              ),
              errorStyle: TextStyle(
                fontSize: 11,
                color: state.status == TextFormFieldStatus.ready
                    ? MealieColors.orange
                    : state.status == TextFormFieldStatus.invalid
                        ? Colors.red
                        : Colors.green,
              ),
              alignLabelWithHint: true,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              errorText: state.status == TextFormFieldStatus.ready
                  ? "New recipe names must be unique"
                  : state.status == TextFormFieldStatus.invalid
                      ? state.errorMessage
                      : "Great name!",
            ),
            onChanged: context.read<TextFormFieldCubit>().validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          );
        },
      ),
    );
  }
}

class TextFormFieldCubit extends Cubit<TextFormFieldState> {
  TextFormFieldCubit({
    required this.manualCubit,
  }) : super(const TextFormFieldState(
          status: TextFormFieldStatus.ready,
        ));

  final ManualCubit manualCubit;

  void validate(value) {
    if (value.length > 0) {
      emit(state.copyWith(status: TextFormFieldStatus.valid));
    } else {
      emit(state.copyWith(
        status: TextFormFieldStatus.invalid,
        errorMessage: "This field is required",
      ));
    }
  }
}

enum TextFormFieldStatus {
  ready,
  valid,
  invalid,
  error,
}

class TextFormFieldState extends Equatable {
  const TextFormFieldState({
    required this.status,
    this.errorMessage,
  });

  final TextFormFieldStatus status;
  final String? errorMessage;

  TextFormFieldState copyWith({
    TextFormFieldStatus? status,
    String? errorMessage,
  }) {
    return TextFormFieldState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
