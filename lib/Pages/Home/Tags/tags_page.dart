import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:maize/Pages/Home/Tags/tags_cubit.dart';

import 'package:maize/app/app_bloc.dart';
import 'package:maize/colors.dart';
import 'package:mealie_repository/mealie_repository.dart';

class TagsPage extends StatelessWidget {
  TagsPage({super.key});
  final TextEditingController tfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return BlocProvider(
        create: (_) => TagsCubit(appBloc: context.read<AppBloc>()),
        child: BlocBuilder<TagsCubit, TagsState>(
          builder: (context, state) {
            switch (state.status) {
              case TagsStatus.loading:
                return _LoadingScreen();
              case TagsStatus.ready:
                return _LoadedScreen(
                  tfController: tfController,
                );
              case TagsStatus.error:
                return _ErrorScreen(state: state);
            }
          },
        ),
      );
    });
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Loading...",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.state});
  final TagsState state;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(state.errorMessage ?? "An undocumented error has occured."),
    );
  }
}

class _LoadedScreen extends StatelessWidget {
  const _LoadedScreen({
    required this.tfController,
  });

  final TextEditingController tfController;

  @override
  Widget build(BuildContext context) {
    final TagsCubit tagsCubit = context.read<TagsCubit>();
    return RefreshIndicator(
      onRefresh: () =>
          Future.sync(() => tagsCubit.state.pagingController.refresh()),
      child: ListView(
        shrinkWrap: true,
        children: [
          _SearchTextField(
            tfController: tfController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PagedListView<int, Tag>(
              pagingController: tagsCubit.state.pagingController,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              builderDelegate: PagedChildBuilderDelegate<Tag>(
                  itemBuilder: (context, tag, index) {
                return TagCard(tag: tag);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class TagCard extends StatelessWidget {
  const TagCard({super.key, required this.tag});
  final Tag tag;
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            color: MealieColors.orange,
            height: 50,
            width: 8,
          ),
          const SizedBox(width: 10),
          const Icon(
            FontAwesomeIcons.tags,
            color: Colors.black45,
          ),
          const SizedBox(width: 18),
          Text(
            tag.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();

                const SnackBar snackBar = SnackBar(
                  content: Text('This feature has not yet been implemented.'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical))
        ],
      ),
    );
  }
}

class _SearchTextField extends StatefulWidget {
  const _SearchTextField({
    required this.tfController,
  });
  final TextEditingController tfController;

  @override
  State<StatefulWidget> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<_SearchTextField> {
  @override
  Widget build(BuildContext context) {
    final RestartableTimer timer =
        RestartableTimer(const Duration(seconds: 1), () {
      if (widget.tfController.text.isNotEmpty) {
        context.read<TagsCubit>().searchTags(widget.tfController.value.text);
      }
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: TextField(
          controller: widget.tfController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search...",
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: widget.tfController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.tfController.clear();
                      context.read<TagsCubit>().clearSearch();
                    },
                    icon: const Icon(Icons.clear))
                : null,
          ),
          onChanged: (query) {
            // Wait until 1 second has passed after final keypress before searching
            timer.reset();
            setState(() {});
          },
        ),
      ),
    );
  }
}
