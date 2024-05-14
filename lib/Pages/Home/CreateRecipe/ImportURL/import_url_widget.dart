import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maize/Pages/Home/CreateRecipe/ImportURL/import_url_cubit.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';

class ImportURLWidget extends StatelessWidget {
  const ImportURLWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImportURLCubit(
        appBloc: context.read<AppBloc>(),
        homeCubit: context.read<HomeCubit>(),
      ),
      child: BlocBuilder<ImportURLCubit, ImportURLState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Scrape Recipe",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      "Scrape a recipe by url. Provide the url for the site you want to scrape and Mealie will attempt to scrape the recipe from that site and add it to your collection."),
                  const SizedBox(height: 10),
                  _RecipeURLTextFormField(
                    importURLCubit: context.read<ImportURLCubit>(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: state.includeTags,
                        onChanged: context
                            .read<ImportURLCubit>()
                            .toggleImportOriginalKeywordAsTags,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Import original keywords as tags",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  // Commented out because this is not a feature I think is really necessary.
                  // Row(
                  //   children: [
                  //     Checkbox(value: false, onChanged: (_) {}),
                  //     const SizedBox(width: 10),
                  //     const Text("Stay in Edit mode"),
                  //   ],
                  // ),
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
                        onTap: context.read<ImportURLCubit>().create,
                        child: state.status == ImportURLStatus.loading
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

class _RecipeURLTextFormField extends StatelessWidget {
  _RecipeURLTextFormField({
    required this.importURLCubit,
  });

  final TextEditingController textEditingController = TextEditingController();
  final ImportURLCubit importURLCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TextFormFieldCubit(importURLCubit: importURLCubit),
      child: BlocBuilder<TextFormFieldCubit, TextFormFieldState>(
        builder: (context, state) {
          return TextFormField(
            controller: textEditingController,
            autocorrect: false,
            keyboardType: TextInputType.url,
            onFieldSubmitted: (_) => importURLCubit.create(),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                FontAwesomeIcons.link,
                color: MealieColors.orange,
                size: 18,
              ),
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(width: 0.0, style: BorderStyle.none),
              ),
              filled: true,
              labelText: 'Recipe URL',
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
                  ? "Copy and paste a valid link from your recipe website"
                  : state.status == TextFormFieldStatus.invalid
                      ? "Must be a valid URL"
                      : "Looks good!",
            ),
            validator: context.read<TextFormFieldCubit>().validate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          );
        },
      ),
    );
  }
}

class TextFormFieldCubit extends Cubit<TextFormFieldState> {
  TextFormFieldCubit({
    required this.importURLCubit,
  }) : super(const TextFormFieldState(
          status: TextFormFieldStatus.ready,
        ));

  final ImportURLCubit importURLCubit;

  String? validate(value) {
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(value ?? '');

    if (matches.length == 1) {
      emit(state.copyWith(status: TextFormFieldStatus.valid));
      importURLCubit.updateURL(value);
    } else {
      emit(state.copyWith(status: TextFormFieldStatus.invalid));
    }

    return null;
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
