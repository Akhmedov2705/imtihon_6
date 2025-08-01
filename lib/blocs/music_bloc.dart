import 'package:audio_example/models/track.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc()
    : super(
        MusicState(
          activeId: null,
          activeMusic: null,
          liked: [],
          recommended: [
            Track(
              id: 1,
              isLiked: false,
              assetPath: 'assets/audio/music1.mp3',
              title: 'Believer',
              imagePath: 'assets/images/music1.png',
            ),
            Track(
              id: 2,
              isLiked: false,
              assetPath: 'assets/audio/music2.mp3',
              title: 'Moment Apart',
              imagePath: 'assets/images/music2.png',
            ),
            Track(
              id: 3,
              isLiked: false,
              assetPath: 'assets/audio/music3.mp3',
              title: 'Shortwave',
              imagePath: 'assets/images/music3.png',
            ),
          ],
        ),
      ) {
    on<LikeMusicEvent>((LikeMusicEvent event, emit) {
      final Track music = state.recommended.firstWhere(
        (element) => element.id == event.id,
      );
      List<Track> liked = [];
      int index = state.liked.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        liked = state.liked;
        liked.add(music);
      }
      emit(state.copyWith(liked: liked));
    });
    on<DisLikeMusicEvent>((event, emit) {
      List<Track> liked = [];
      int index = state.liked.indexWhere((element) => element.id == event.id);
      if (index != -1) {
        liked = state.liked;
        liked.removeAt(index);
        emit(state.copyWith(liked: liked));
      }
    });
    on<ChangeMusicEvent>((ChangeMusicEvent event, emit) {
      final Track music = state.recommended.firstWhere(
        (element) => element.id == event.id,
      );
      emit(state.copyWith(activeId: event.id, activeMusic: music));
    });
  }
}
