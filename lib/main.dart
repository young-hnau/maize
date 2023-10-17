import 'package:flutter/material.dart';
import 'package:mealie_mobile/app/app.dart';
import 'package:mealie_mobile/app/bloc_observer.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
