part of 'recipe_page.dart';

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
          CircularProgressIndicator(color: MealieColors.orange),
        ],
      ),
    );
  }
}
