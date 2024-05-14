import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required this.appBloc})
      : super(const CategoriesState(
          status: CategoriesStatus.ready,
        ));

  final AppBloc appBloc;

  void reset() {
    emit(state.copyWith(status: CategoriesStatus.ready));
  }

  Future<void> logout() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    p.remove('__access_token__');
    appBloc.refreshApp();
  }
}
