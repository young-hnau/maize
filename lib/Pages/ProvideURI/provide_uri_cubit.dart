import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'provide_uri_state.dart';

class ProvideURICubit extends Cubit<ProvideURIState> {
  ProvideURICubit({required this.appBloc})
      : super(const ProvideURIState(status: ProvideURIStatus.ready)) {
    _initialize();
  }

  final AppBloc appBloc;
  late StreamSubscription sub;

  Future<void> _initialize() async {
    sub = appBloc.repo.errorStream.stream.listen(
      (String? message) {
        emit(state.copyWith(status: state.status, errorMessage: message));
      },
    );
  }

  Future<void> verifyURI(String uriString) async {
    emit(state.copyWith(status: ProvideURIStatus.loading));

    try {
      final Uri uri = Uri.parse(uriString);
      appBloc.updateMealieRepoURI(uri);
      MealieRepository mealieRepository = appBloc.repo.copyWith(uri: uri);
      if (await mealieRepository.uriIsValid(save: true)) {
        emit(state.copyWith(status: ProvideURIStatus.valid));
        sub.cancel();

        await Future.delayed(const Duration(seconds: 1));

        appBloc.refreshApp();
      } else {
        emit(state.copyWith(
            status: ProvideURIStatus.invalid,
            errorMessage: state.errorMessage ??
                "There was an error connecting to this instance."));
      }
    } on FormatException catch (error) {
      emit(state.copyWith(
        status: ProvideURIStatus.invalid,
        errorMessage: error.message,
      ));
    }
  }

  void reset() {
    emit(state.copyWith(status: ProvideURIStatus.ready));
  }
}
