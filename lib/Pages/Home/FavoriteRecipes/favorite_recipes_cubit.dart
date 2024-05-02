import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealie_mobile/app/app_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_recipes_state.dart';

class FavoriteRecipesCubit extends Cubit<FavoriteRecipesState> {
  FavoriteRecipesCubit({required this.appBloc})
      : super(const FavoriteRecipesState(
          status: FavoriteRecipesStatus.ready,
        ));

  final AppBloc appBloc;

  void reset() {
    emit(state.copyWith(status: FavoriteRecipesStatus.ready));
  }

  Future<void> logout() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    p.remove('__access_token__');
    appBloc.refreshApp();
  }
}
