part of 'recipe_page.dart';

class _Header extends StatelessWidget {
  const _Header({
    required this.imageUrl,
    required this.recipeCubit,
  });

  final String imageUrl;
  final RecipeCubit recipeCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 200,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(height: 60);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: recipeCubit.state.status == RecipeStatus.loaded
              ? _LoadedButtons(recipeCubit: recipeCubit)
              : recipeCubit.state.status == RecipeStatus.editing
                  ? _EditingButtons(recipeCubit: recipeCubit)
                  : Container(),
        )
      ],
    );
  }
}

class _LoadedButtons extends StatelessWidget {
  const _LoadedButtons({
    required this.recipeCubit,
  });

  final RecipeCubit recipeCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundedIconButton(
          onTap: () {
            const SnackBar snackBar = SnackBar(
              content: Text('This feature has not yet been implemented.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          color: MealieColors.blue,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.heart),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () {
            const SnackBar snackBar = SnackBar(
              content: Text('This feature has not yet been implemented.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          color: MealieColors.blue,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.timeline),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () => recipeCubit.beginEditing(),
          color: MealieColors.blue,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.penToSquare),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () {
            const SnackBar snackBar = SnackBar(
              content: Text('This feature has not yet been implemented.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          color: MealieColors.blue,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.stopwatch),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () {
            const SnackBar snackBar = SnackBar(
              content: Text('This feature has not yet been implemented.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          color: MealieColors.blue,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
        ),
      ],
    );
  }
}

class _EditingButtons extends StatelessWidget {
  const _EditingButtons({
    required this.recipeCubit,
  });

  final RecipeCubit recipeCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundedIconButton(
          onTap: () {
            const SnackBar snackBar = SnackBar(
              content: Text('This feature has not yet been implemented.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          color: MealieColors.brightRed,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.trash),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () {
            const SnackBar snackBar = SnackBar(
              content: Text('This feature has not yet been implemented.'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          color: MealieColors.lightBlue,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.code),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () => recipeCubit.endEditing(),
          color: Colors.white,
          iconColor: Colors.black,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.xmark),
        ),
        const SizedBox(width: 4),
        _RoundedIconButton(
          onTap: () => recipeCubit.saveRecipe(),
          color: MealieColors.green,
          iconColor: Colors.white,
          iconSize: 20,
          icon: const FaIcon(FontAwesomeIcons.floppyDisk),
        ),
      ],
    );
  }
}
