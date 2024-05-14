import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maize/Pages/Home/CreateCookbook/create_cookbook_page.dart';
import 'package:maize/Pages/Home/CreateRecipe/Page/create_recipe_page.dart';
import 'package:maize/Pages/Home/Page/home_cubit.dart';
import 'package:maize/colors.dart';

abstract class MenuItems {
  static final create = MenuItem(
    text: "Recipe",
    subtext: "Create a new recipe",
    icon: FontAwesomeIcons.penToSquare,
    action: (BuildContext context) {
      context.read<HomeCubit>().setScreen(CreateRecipePage(
            homeCubit: context.read<HomeCubit>(),
          ));
      Navigator.of(context.read<HomeCubit>().state.context).pop();
    },
  );
  static final cookbook = MenuItem(
    text: "Cookbook",
    subtext: "Create a new cookbook",
    icon: FontAwesomeIcons.book,
    action: (BuildContext context) {
      context.read<HomeCubit>().setScreen(const CreateCookbookPage());
      Navigator.of(context.read<HomeCubit>().state.context).pop();
    },
  );

  static final List<MenuItem> items = [create, cookbook];
  static int get length => (items.length * 2) - 1;

  static List<DropdownMenuItem> get dropDownMenuItems {
    List<DropdownMenuItem> menuItems = [];
    for (int index = 0; index < items.length; index++) {
      MenuItem item = items[index];
      menuItems.add(
        DropdownMenuItem<MenuItem>(value: item, child: item.build),
      );
      if (index < items.length - 1) {
        menuItems.add(
          const DropdownMenuItem<Divider>(
            enabled: false,
            child: Divider(),
          ),
        );
      }
    }
    return menuItems;
  }

  static void onChanged(BuildContext context, MenuItem item) =>
      item.action(context);
}

class CreateButtonDropDown extends StatelessWidget {
  const CreateButtonDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: SizedBox(
          height: 50,
          width: 125,
          child: Card(
            elevation: 3,
            color: Colors.grey[200],
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.add,
                  color: MealieColors.orange,
                  size: 30,
                ),
                Text("Create")
              ],
            ),
          ),
        ),
        items: MenuItems.dropDownMenuItems,
        onChanged: (value) => MenuItems.onChanged(context, value! as MenuItem),
        dropdownStyleData: DropdownStyleData(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          offset: const Offset(0, 0),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.generate(MenuItems.length, (index) {
              if (index % 2 == 0) {
                return 48;
              }
              return 18;
            }),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
        buttonStyleData: ButtonStyleData(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.subtext,
    required this.icon,
    required this.action,
  });

  final String text;
  final String subtext;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
              Text(
                subtext,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),
        )
      ],
    );
  }
}
