import 'package:flutter/material.dart';
import 'package:maize/app/app.dart';
import 'package:maize/app/bloc_observer.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
