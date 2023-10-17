import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:mealie_repository/mealie_repository.dart';

part 'provide_uri_state.dart';

class ProvideURICubit extends Cubit<ProvideURIState> {
  ProvideURICubit({required this.appBloc})
      : super(const ProvideURIState(status: ProvideURIStatus.ready));

  final AppBloc appBloc;

  Future<void> verifyURI(String uriString) async {
    emit(state.copyWith(status: ProvideURIStatus.loading));

    try {
      final Uri uri = Uri.parse(uriString);
      if (await MealieRepository(uri: uri).uriIsValid(save: true)) {
        emit(state.copyWith(status: ProvideURIStatus.valid));

        await Future.delayed(const Duration(seconds: 1));

        appBloc.refreshApp();
      } else {
        emit(state.copyWith(
            status: ProvideURIStatus.invalid,
            errorMessage:
                "There was an issue accessing this Mealie instance."));
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
