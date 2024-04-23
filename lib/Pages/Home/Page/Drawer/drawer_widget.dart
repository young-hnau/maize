part of '../home_page.dart';

class _Drawer extends Drawer {
  const _Drawer({
    required this.appBloc,
    required this.homeCubit,
    required this.context,
  });
  // {
  //   final DrawerCubit drawerCubit = DrawerCubit(appBloc: appBloc);
  // }

  final AppBloc appBloc;
  final HomeCubit homeCubit;
  final BuildContext context;

  @override
  Widget? get child => BlocProvider(
        create: (_) => DrawerCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<DrawerCubit, DrawerState>(builder: (context, state) {
          return Column(
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
                          children: [
                            Text(appBloc.state.user.fullName.toString())
                          ],
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
                        CreateDropDown(),

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
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
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
        }),
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
