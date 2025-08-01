part of 'music_bloc.dart';

class MusicState {
  final List<Track> recommended;
  final List<Track> liked;
  final Track? activeMusic;
  final int? activeId;
  MusicState({
    required this.activeId,
    required this.activeMusic,
    required this.liked,
    required this.recommended,
  });

  MusicState copyWith({
    List<Track>? recommended,
    List<Track>? liked,
    Track? activeMusic,
    int? activeId,
  }) {
    return MusicState(
      recommended: recommended ?? this.recommended,
      liked: liked ?? this.liked,
      activeMusic: activeMusic ?? this.activeMusic,
      activeId: activeId ?? this.activeId,
    );
  }
}
