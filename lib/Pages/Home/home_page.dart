import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mealie_mobile/Pages/Home/Categories/categories_page.dart';
import 'package:mealie_mobile/Pages/Home/MealPlanner/meal_planner_page.dart';
import 'package:mealie_mobile/Pages/Home/Search/search_page.dart';
import 'package:mealie_mobile/Pages/Home/ShoppingLists/shopping_lists_page.dart';
import 'package:mealie_mobile/Pages/Home/Tags/tags_page.dart';
import 'package:mealie_mobile/Pages/Home/Timeline/timeline_page.dart';
import 'package:mealie_mobile/Pages/Home/Tools/tools_page.dart';
import 'package:mealie_mobile/Pages/Home/home_cubit.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_mobile/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, snapshot) {
      return BlocProvider(
        create: (_) => HomeCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          switch (state.status) {
            case HomeStatus.error:
              return _ErrorScreen(state: state);
            case HomeStatus.ready:
            case HomeStatus.loading:
            default:
              return Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: _AppBar(
                  appBloc: context.read<AppBloc>(),
                  homeCubit: context.read<HomeCubit>(),
                ),
                drawer: _Drawer(
                  appBloc: context.read<AppBloc>(),
                  homeCubit: context.read<HomeCubit>(),
                  context: context,
                ),
                body: state.onScreen,
              );
          }
        }),
      );
    });
  }
}

class _Drawer extends Drawer {
  const _Drawer({
    required this.appBloc,
    required this.homeCubit,
    required this.context,
  });

  final AppBloc appBloc;
  final HomeCubit homeCubit;
  final BuildContext context;

  @override
  Widget? get child => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 40, left: 16, right: 16, bottom: 10),
                color: Colors.grey[200],
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      width: 50,
                      height: 50,
                      child: Image.network(
                          appBloc.repo.uri
                              .replace(
                                  path:
                                      '/api/media/users/${appBloc.state.user.id}/profile.webp')
                              .toString(),
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [Text(appBloc.state.user.fullName.toString())],
                      // TODO: Link to favorite recipes once they are available in the app
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 125,
                      child: Card(
                        elevation: 3,
                        color: Colors.grey[200],
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const InkWell(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.add,
                              color: MealieColors.orange,
                              size: 30,
                            ),
                            Text("Create")
                          ],
                        )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _PageSelectionTile(
                      icon: Icons.search,
                      text: "Search",
                      onTap: () {
                        homeCubit.setScreen(SearchPage());
                        Navigator.pop(context);
                      },
                    ),
                    _PageSelectionTile(
                      icon: Icons.calendar_month,
                      text: "Meal Planner",
                      onTap: () {
                        homeCubit.setScreen(const MealPlannerPage());
                        Navigator.pop(context);
                      },
                    ),
                    _PageSelectionTile(
                      icon: Icons.checklist_rounded,
                      text: "Shopping Lists",
                      onTap: () {
                        homeCubit.setScreen(const ShoppingListsPage());
                        Navigator.pop(context);
                      },
                    ),
                    _PageSelectionTile(
                      icon: Icons.view_timeline,
                      text: "Timeline",
                      onTap: () {
                        homeCubit.setScreen(const TimelinePage());
                        Navigator.pop(context);
                      },
                    ),
                    _PageSelectionTile(
                      icon: Icons.sell,
                      text: "Categories",
                      onTap: () {
                        homeCubit.setScreen(const CategoriesPage());
                        Navigator.pop(context);
                      },
                    ),
                    _PageSelectionTile(
                      icon: Icons.sell,
                      text: "Tags",
                      onTap: () {
                        homeCubit.setScreen(const TagsPage());
                        Navigator.pop(context);
                      },
                    ),
                    _PageSelectionTile(
                      icon: Icons.blender,
                      text: "Tools",
                      onTap: () {
                        homeCubit.setScreen(const ToolsPage());
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    // TODO: Display cookbooks
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Cookbooks",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey[400],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _PageSelectionTile(
                  text: "Language",
                  icon: Icons.language,
                  onTap: () {},
                ),
                _PageSelectionTile(
                  text: "Dark Mode",
                  icon: Icons.dark_mode,
                  onTap: () {},
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      );
}

class _PageSelectionTile extends StatelessWidget {
  const _PageSelectionTile({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final Function onTap;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black.withOpacity(0.5),
            ),
            const SizedBox(width: 30),
            Text(text)
          ],
        ),
      ),
    );
  }
}

class _AppBar extends AppBar {
  _AppBar({
    required this.appBloc,
    required this.homeCubit,
  });

  final AppBloc appBloc;
  final HomeCubit homeCubit;
  @override
  Color? get backgroundColor => MealieColors.orange;

  @override
  Color? get foregroundColor => Colors.white;

  @override
  Widget? get title => Row(
        children: [
          InkWell(
            onTap: () => homeCubit.setScreen(SearchPage()),
            child: SvgPicture.asset('assets/mealie_logo.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcATop)),
          ),
          const SizedBox(width: 5),
          const Text("Mealie"),
        ],
      );

  @override
  double? get titleSpacing => 5;

  @override
  List<Widget>? get actions => [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(
          onPressed: () => appBloc.add(AppLogoutRequested()),
          icon: const Icon(Icons.logout),
        ),
      ];
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Error",
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(height: 15),
          Text(state.errorMessage.toString())
        ],
      ),
    );
  }
}
