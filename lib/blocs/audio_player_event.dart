part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent {}

class PlayTrack extends AudioPlayerEvent {
  final Track track;
  PlayTrack(this.track);
}

class PauseTrack extends AudioPlayerEvent {}

class TogglePlayPause extends AudioPlayerEvent {}

class SeekTrack extends AudioPlayerEvent {
  final Duration position;
  SeekTrack(this.position);
}

class _InternalUpdate extends AudioPlayerEvent {
  final Duration position;
  final Duration duration;
  final bool playing;
  final ProcessingState processingState;

  _InternalUpdate({
    required this.position,
    required this.duration,
    required this.playing,
    required this.processingState,
  });
}
