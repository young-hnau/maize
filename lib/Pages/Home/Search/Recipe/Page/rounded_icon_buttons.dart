part of 'recipe_page.dart';

class _RoundedIconButton extends StatelessWidget {
  const _RoundedIconButton({
    this.onTap,
    this.color,
    this.iconColor,
    this.iconSize = 24.0,
    required this.icon,
    // ignore: unused_element
    this.padding,
  });

  final VoidCallback? onTap;
  final Color? color;
  final Color? iconColor;
  final double iconSize;
  final Widget icon;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(iconSize * 2))),
      height: iconSize * 2,
      width: iconSize * 2,
      child: IconButton(
        onPressed: onTap,
        icon: icon,
        color: iconColor,
        iconSize: iconSize,
      ),
    );
  }
}
