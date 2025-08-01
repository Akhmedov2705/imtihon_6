import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/track.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  static const _key = 'liked_tracks';
  final SharedPreferences prefs;

  LikeBloc(this.prefs)
    : super(LikeState(liked: prefs.getStringList(_key)?.toSet() ?? {})) {
    on<ToggleLike>((event, emit) async {
      final set = Set<String>.from(state.liked);
      if (set.contains(event.track.assetPath)) {
        set.remove(event.track.assetPath);
      } else {
        set.add(event.track.assetPath);
      }
      await prefs.setStringList(_key, set.toList());
      emit(LikeState(liked: set));
    });
  }
}
