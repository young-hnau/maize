import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  static Page page() => const MaterialPage<void>(child: LoadingPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Connecting to base station...",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 15),
          CircularProgressIndicator()
        ],
      )),
    );
  }
}
