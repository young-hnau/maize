part of 'recipe_page.dart';

class _StarRating extends StatelessWidget {
  const _StarRating({
    required this.rating,
    required this.setRating,
    this.spacing = 8.0,
    this.iconSize,
  });

  final double rating;
  final double? iconSize;
  final double? spacing;
  final Function setRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: List<Widget>.generate(
            rating.toInt(),
            growable: false,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing!),
              child: IconButton(
                onPressed: () => setRating(index.toDouble() + 1),
                icon: Icon(
                  Icons.star,
                  color: MealieColors.red,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: List<Widget>.generate(
            (5 - (rating)).toInt(),
            growable: false,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing!),
              child: IconButton(
                onPressed: () => setRating(index.toDouble() + 1 + rating),
                icon: Icon(
                  Icons.star_border,
                  color: MealieColors.peach,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
