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
import 'package:mealie_mobile/Pages/Home/Page/home_cubit.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_mobile/colors.dart';

part 'Drawer/drawer_widget.dart';

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
