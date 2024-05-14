import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maize/app/app_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit({required this.appBloc})
      : super(const TagsState(
          status: TagsStatus.ready,
        ));

  final AppBloc appBloc;

  void reset() {
    emit(state.copyWith(status: TagsStatus.ready));
  }

  Future<void> logout() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    p.remove('__access_token__');
    appBloc.refreshApp();
  }
}
