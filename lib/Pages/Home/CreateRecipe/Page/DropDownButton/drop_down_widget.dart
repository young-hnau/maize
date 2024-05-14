import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maize/Pages/Home/CreateRecipe/BulkURLImport/bulk_url_import.dart';
import 'package:maize/Pages/Home/CreateRecipe/DebugScraper/debug_scraper_widget.dart';
import 'package:maize/Pages/Home/CreateRecipe/FromImage/from_image_widget.dart';
import 'package:maize/Pages/Home/CreateRecipe/ImportURL/import_url_widget.dart';
import 'package:maize/Pages/Home/CreateRecipe/ImportZIP/import_zip_widget.dart';
import 'package:maize/Pages/Home/CreateRecipe/Manual/manual_widget.dart';
import 'package:maize/Pages/Home/CreateRecipe/Page/create_recipe_cubit.dart';
import 'package:maize/colors.dart';

abstract class MenuItems {
  static final url = MenuItem(
    text: "Import from URL",
    icon: FontAwesomeIcons.link,
    action: (BuildContext context) {
      context.read<CreateRecipeCubit>().setWidget(const ImportURLWidget());
    },
  );
  static final manual = MenuItem(
    text: "Create Recipe",
    icon: FontAwesomeIcons.penToSquare,
    action: (BuildContext context) {
      context.read<CreateRecipeCubit>().setWidget(const ManualWidget());
    },
  );
  static final zip = MenuItem(
    text: "Import from .zip",
    icon: FontAwesomeIcons.fileZipper,
    action: (BuildContext context) {
      context.read<CreateRecipeCubit>().setWidget(const ImportZIPWidget());
    },
  );
  static final image = MenuItem(
    text: "Create recipe from image",
    icon: FontAwesomeIcons.image,
    action: (BuildContext context) {
      context.read<CreateRecipeCubit>().setWidget(const FromImageWidget());
    },
  );
  static final bulkURL = MenuItem(
    text: "Bulk URL Import",
    icon: FontAwesomeIcons.link,
    action: (BuildContext context) {
      context.read<CreateRecipeCubit>().setWidget(const BulkURLImportWidget());
    },
  );
  static final debugScraper = MenuItem(
    text: "Debug Scraper",
    icon: FontAwesomeIcons.robot,
    action: (BuildContext context) {
      context.read<CreateRecipeCubit>().setWidget(const DebugScraperWidget());
    },
  );

  static final List<MenuItem> items = [
    url,
    manual,
    zip,
    image,
    bulkURL,
    debugScraper,
  ];

  static List<DropdownMenuItem> get dropDownMenuItems =>
      List<DropdownMenuItem>.generate(
        items.length,
        (index) => DropdownMenuItem<MenuItem>(
          value: items[index],
          child: items[index].build,
        ),
      );

  static void onChanged(BuildContext context, MenuItem item) =>
      item.action(context);
}

class ImportTypeDropDown extends StatelessWidget {
  const ImportTypeDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _DropDownCubit(),
      child: BlocBuilder<_DropDownCubit, _DropDownState>(
        builder: (context, state) {
          return DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: Card(
                elevation: 3,
                color: MealieColors.orange,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        context.read<_DropDownCubit>().state.item.icon,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        context.read<_DropDownCubit>().state.item.text,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        FontAwesomeIcons.angleDown,
                        color: Colors.white,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
              items: MenuItems.dropDownMenuItems,
              onChanged: (value) {
                context.read<_DropDownCubit>().setWidget(value! as MenuItem);
                MenuItems.onChanged(context, value);
              },
              dropdownStyleData: DropdownStyleData(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                offset: const Offset(0, 0),
              ),
              menuItemStyleData: MenuItemStyleData(
                customHeights: List<double>.filled(MenuItems.items.length, 38),
                padding: const EdgeInsets.only(left: 16, right: 16),
              ),
              buttonStyleData: ButtonStyleData(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DropDownCubit extends Cubit<_DropDownState> {
  _DropDownCubit()
      : super(
          _DropDownState(item: MenuItems.items.first),
        );

  void setWidget(MenuItem item) {
    emit(state.copyWith(item: item));
  }
}

class _DropDownState extends Equatable {
  const _DropDownState({required this.item});

  final MenuItem item;

  _DropDownState copyWith({
    MenuItem? item,
  }) {
    return _DropDownState(item: item ?? this.item);
  }

  @override
  List<Object?> get props => [item];
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
    required this.action,
  });

  final String text;
  final IconData icon;
  final Function(BuildContext) action;

  Widget get build {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.black54,
          size: 24,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        )
      ],
    );
  }
}
