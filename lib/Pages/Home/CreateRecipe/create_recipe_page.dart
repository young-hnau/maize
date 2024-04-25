import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mealie_mobile/colors.dart';

class CreateRecipePage extends StatelessWidget {
  const CreateRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/diet.svg",
                        width: 200,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Recipe Creation",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Select one of the various ways to create a recipe",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: MealieColors.orange,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: const Text(
                              "Drop Down Button",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
